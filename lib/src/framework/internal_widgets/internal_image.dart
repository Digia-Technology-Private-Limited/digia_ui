import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';

import '../../dui_dev_config.dart';
import '../../init/digia_ui_manager.dart';
import '../data_type/adapted_types/file.dart';
import '../expr/default_scope_context.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../utils/network_util.dart' show hasExtension;

/// Internal image widget that optimizes image loading by determining
/// the actual render size before fetching the image.
class InternalImage extends StatefulWidget {
  final Object? imageSourceExpr;
  final RenderPayload payload;
  final String? imageType;
  final BoxFit? fit;
  final Alignment? alignment;
  final Color? svgColor;
  final String? placeholderType;
  final String? placeholderSrc;
  final Object? errorImage;

  const InternalImage({
    super.key,
    required this.imageSourceExpr,
    required this.payload,
    this.imageType,
    this.fit,
    this.alignment,
    this.svgColor,
    this.placeholderType,
    this.placeholderSrc,
    this.errorImage,
  });

  @override
  State<InternalImage> createState() => _InternalImageState();
}

class _InternalImageState extends State<InternalImage> {
  final GlobalKey _imageKey = GlobalKey();
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateImageSize();
    });
  }

  void _updateImageSize() {
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final newSize = renderBox.size;
      if (_imageSize != newSize) {
        if (!mounted) return;
        setState(() {
          _imageSize = newSize;
        });
      }
    }
  }

  @override
  void didUpdateWidget(InternalImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageSourceExpr != widget.imageSourceExpr) {
      _imageSize = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateImageSize());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateImageSize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ImageProvider _createImageProvider(Object? imageSource) {
    if (imageSource is List<AdaptedFile> && imageSource.isNotEmpty) {
      final firstFile = imageSource.first;
      if (firstFile.isWeb && firstFile.xFile?.path != null) {
        return CachedNetworkImageProvider(firstFile.xFile!.path);
      } else if (firstFile.isMobile && firstFile.path != null) {
        return FileImage(File(firstFile.path!));
      }
      throw Exception('Invalid File source in list');
    }

    if (imageSource is AdaptedFile) {
      if (imageSource.isWeb && imageSource.xFile?.path != null) {
        return CachedNetworkImageProvider(imageSource.xFile!.path);
      } else if (imageSource.isMobile && imageSource.path != null) {
        return FileImage(File(imageSource.path!));
      }
      throw Exception('Invalid File source');
    }

    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        final DigiaUIHost? host = DigiaUIManager().host;
        final String finalUrl;
        if (host is DashboardHost && host.resourceProxyUrl != null) {
          finalUrl = '${host.resourceProxyUrl}${Uri.encodeFull(imageSource)}';
        } else {
          finalUrl = imageSource;
        }
        return CachedNetworkImageProvider(finalUrl);
      } else {
        return ResourceProvider.maybeOf(widget.payload.buildContext)
                ?.getImageProvider(imageSource) ??
            AssetImage(imageSource);
      }
    }

    throw Exception('Unsupported image source type');
  }

  Widget _buildSvgImage(Object? imageSource) {
    final color = widget.svgColor;
    if (imageSource is String) {
      Widget svgWidget;
      if (imageSource.startsWith('http')) {
        final DigiaUIHost? host = DigiaUIManager().host;
        final String finalUrl;
        if (host is DashboardHost && host.resourceProxyUrl != null) {
          finalUrl = '${host.resourceProxyUrl}${Uri.encodeFull(imageSource)}';
        } else {
          finalUrl = imageSource;
        }
        svgWidget = SvgPicture.network(
          finalUrl,
          colorFilter:
              color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: widget.fit ?? BoxFit.contain,
          alignment: widget.alignment ?? Alignment.center,
        );
      } else {
        svgWidget = SvgPicture.asset(
          imageSource,
          colorFilter:
              color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: widget.fit ?? BoxFit.contain,
          alignment: widget.alignment ?? Alignment.center,
        );
      }

      return svgWidget;
    }

    throw Exception('Unsupported image source type');
  }

  Widget _buildAvifImage(ImageProvider imageProvider) {
    return AvifImage(
      image: imageProvider,
      fit: widget.fit,
      alignment: widget.alignment ?? Alignment.center,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget(error);
      },
    );
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreator() {
    final placeholderType = widget.placeholderType;
    final placeholderSrc = widget.placeholderSrc;

    if (placeholderType == null || placeholderType.isEmpty) {
      return null;
    }

    return (context) {
      switch (placeholderType.toLowerCase()) {
        case 'blurhash':
          if (placeholderSrc != null && placeholderSrc.isNotEmpty) {
            return BlurHash(
              hash: placeholderSrc,
              duration: const Duration(milliseconds: 300),
            );
          }
          break;
        case 'network':
          if (placeholderSrc != null && placeholderSrc.startsWith('http')) {
            return CachedNetworkImage(imageUrl: placeholderSrc);
          }
          break;
        case 'asset':
          if (placeholderSrc != null) {
            return Image.asset(placeholderSrc);
          }
          break;
        case 'lottie':
          if (placeholderSrc != null && placeholderSrc.endsWith('.json')) {
            return LottieBuilder.asset(placeholderSrc, fit: BoxFit.contain);
          }
          break;
      }
      return Container(color: Colors.transparent);
    };
  }

  Widget _buildErrorWidget(Object error) {
    final errorImageObj = widget.errorImage;
    String? errorImage;

    if (errorImageObj is Map && errorImageObj['errorSrc'] != null) {
      errorImage = errorImageObj['errorSrc'] as String?;
    } else if (errorImageObj is String) {
      errorImage = errorImageObj;
    }
    if (errorImage == null &&
        (DigiaUIManager().host is DashboardHost || kDebugMode)) {
      return Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (errorImage == null) {
      return SizedBox.shrink();
    }

    return Image.asset(errorImage);
  }

  /// Returns null if the provided value is outside the range of 0 to infinity.
  /// Otherwise, returns the original value as an integer.
  int? _validateAndConvertDimension(double? value) {
    if (value == null || value.isNegative || !value.isFinite) {
      return null;
    }

    return value.toInt();
  }

  Widget _buildPlaceholder() {
    // Show a placeholder while waiting for size calculation
    final placeholderBuilder = _placeHolderBuilderCreator();
    if (placeholderBuilder != null) {
      return placeholderBuilder(context);
    }
    return Container(color: Colors.transparent);
  }

  Widget _buildOptimizedImage() {
    if (_imageSize == null) {
      return _buildPlaceholder();
    }

    final maxWidth = _validateAndConvertDimension(_imageSize?.width);
    final maxHeight = _validateAndConvertDimension(_imageSize?.height);
    final dpr = MediaQuery.devicePixelRatioOf(context).round();

    // Evaluate imageSource with render dimensions
    final imageSource = widget.payload.eval(
      widget.imageSourceExpr,
      scopeContext: DefaultScopeContext(variables: {
        'renderWidth': maxWidth,
        'renderHeight': maxHeight,
        'dpr': dpr,
      }),
    );
    final imageType = (widget.imageType ?? 'auto').toLowerCase();

    if (imageType == 'svg' ||
        (imageSource is String && hasExtension(imageSource, ['.svg']))) {
      return _buildSvgImage(imageSource);
    }

    final imageProvider = _createImageProvider(imageSource);

    if (imageType == 'avif' ||
        (imageSource is String && hasExtension(imageSource, ['.avif']))) {
      return _buildAvifImage(imageProvider);
    }

    final imageWidget =
        imageProvider is MemoryImage || imageProvider is FileImage
            ? Image(
                image: imageProvider,
                fit: widget.fit,
                alignment: widget.alignment ?? Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorWidget(error);
                },
              )
            : OctoImage(
                fadeInDuration: const Duration(milliseconds: 200),
                fadeInCurve: Curves.easeIn,
                fadeOutDuration: const Duration(milliseconds: 200),
                fadeOutCurve: Curves.easeOut,
                image: imageProvider,
                fit: widget.fit,
                gaplessPlayback: true,
                placeholderBuilder: _placeHolderBuilderCreator(),
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorWidget(error);
                },
                alignment: widget.alignment ?? Alignment.center,
              );

    return imageWidget;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _imageKey,
      child: _buildOptimizedImage(),
    );
  }
}
