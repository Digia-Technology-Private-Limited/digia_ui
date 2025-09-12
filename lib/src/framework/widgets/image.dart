import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';

import '../../dui_dev_config.dart';
import '../../init/digia_ui_manager.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../data_type/adapted_types/file.dart';
import '../expr/default_scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/network_util.dart' show hasExtension;
import '../utils/widget_util.dart';

class VWImage extends VirtualLeafStatelessWidget<Props> {
  VWImage({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  VWImage.fromValues({
    required String? imageSrc,
    String? imageFit,
  }) : this(
            props: Props({
              'imageSrc': imageSrc,
              'fit': imageFit,
            }),
            commonProps: null,
            parent: null);
  ImageProvider _createImageProvider(
    RenderPayload payload,
    Object? imageSource,
    int? maxHeight,
    int? maxWidth,
    int dpr,
  ) {
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
        return CachedNetworkImageProvider(
          finalUrl,
        );
      } else {
        return ResourceProvider.maybeOf(payload.buildContext)
                ?.getImageProvider(imageSource) ??
            AssetImage(imageSource);
      }
    }

    throw Exception('Unsupported image source type');
  }

  Widget _buildSvgImage(
      Object? imageSource, RenderPayload payload, double opacity) {
    final color = payload.evalColor(props.get('svgColor'));
    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        final DigiaUIHost? host = DigiaUIManager().host;
        final String finalUrl;
        if (host is DashboardHost && host.resourceProxyUrl != null) {
          finalUrl = '${host.resourceProxyUrl}${Uri.encodeFull(imageSource)}';
        } else {
          finalUrl = imageSource;
        }
        return SvgPicture.network(
          finalUrl,
          colorFilter:
              color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: To.boxFit(props.get('fit')),
          alignment: To.alignment(props.get('alignment')) ?? Alignment.center,
        );
      } else {
        return SvgPicture.asset(
          imageSource,
          colorFilter:
              color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(error),
          fit: To.boxFit(props.get('fit')),
          alignment: To.alignment(props.get('alignment')) ?? Alignment.center,
        );
      }
    }

    throw Exception('Unsupported image source type');
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreator() {
    final placeholderType = props.getString('placeholder');
    final placeholderSrc = props.getString('placeholderSrc');

    if (placeholderType == null || placeholderType.isEmpty) {
      return null;
    }

    return (context) {
      switch (placeholderType.toLowerCase()) {
        case 'blurhash':
          return BlurHash(
            hash: placeholderSrc ?? '',
            duration: Duration.zero,
          );
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
    final errorImageObj = props.get('errorImage');
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

  Widget _mayWrapInAspectRatio(Widget child) =>
      wrapInAspectRatio(value: props.get('aspectRatio'), child: child);

  /// Returns null if the provided value is outside the range of 0 to infinity.
  /// Otherwise, returns the original value as an integer.
  int? _validateAndConvertDimension(double? value) {
    if (value == null || value.isNegative || !value.isFinite) {
      return null;
    }

    return value.toInt();
  }

  @override
  Widget render(RenderPayload payload) {
    return _mayWrapInAspectRatio(
      LayoutBuilder(builder: (context, constraints) {
        final maxWidth = _validateAndConvertDimension(constraints.maxWidth);
        final maxHeight = _validateAndConvertDimension(constraints.maxHeight);
        final dpr = MediaQuery.devicePixelRatioOf(context).toInt();

        final imageSource = payload.eval(props.get('imageSrc'),
            scopeContext: DefaultScopeContext(variables: {
              'renderWidth': maxWidth,
              'renderHeight': maxHeight,
              'dpr': dpr,
            }));
        final opacity = payload.eval<double>(props.get('opacity')) ?? 1.0;
        final imageType =
            (props.getString('imageType') ?? 'auto').toLowerCase();

        final fit = To.boxFit(props.get('fit'));
        final alignment =
            To.alignment(props.get('alignment')) ?? Alignment.center;

        // helper method to get the final URL
        String getFinalUrl(String src) {
          final DigiaUIHost? host = DigiaUIManager().host;
          if (host is DashboardHost && host.resourceProxyUrl != null) {
            return '${host.resourceProxyUrl}${Uri.encodeFull(src)}';
          }
          return src;
        }

        // if svg, handle separately
        if (imageType == 'svg' ||
            (imageSource is String && hasExtension(imageSource, ['.svg']))) {
          return _buildSvgImage(imageSource, payload, opacity);
        }

        // get proviider for non-network cases
        final imageProvider = _createImageProvider(
          payload,
          imageSource,
          maxHeight,
          maxWidth,
          dpr,
        );

        // determine if it's a network image
        bool isNetworkImage =
            imageSource is String && imageSource.startsWith('http');
        if (!isNetworkImage) {
          // non-network (asset, memory , file)
          return Opacity(
            opacity: opacity,
            child: imageProvider is MemoryImage
                ? Image(
                    image: imageProvider,
                    fit: fit,
                    alignment: alignment,
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
                    fit: fit,
                    gaplessPlayback: true,
                    placeholderBuilder: _placeHolderBuilderCreator(),
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(error);
                    },
                    alignment: alignment,
                  ),
          );
        }

        // Network images: Use FutureBuilder with cache manager for waiting state
        final url = getFinalUrl(imageSource);
        return FutureBuilder<FileInfo?>(
          future: DefaultCacheManager().downloadFile(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show placeholder during cache/download
              final placeholderBuilder = _placeHolderBuilderCreator();
              return Opacity(
                opacity: opacity,
                child: placeholderBuilder != null
                    ? placeholderBuilder(context)
                    : const SizedBox.shrink(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Opacity(
                opacity: opacity,
                child:
                    _buildErrorWidget(snapshot.error ?? 'Failed to load image'),
              );
            }

            // Image is cached/downloaded, render based on type
            if (kIsWeb) {
              if (imageType == 'avif' || url.endsWith('.avif')) {
                return Opacity(
                  opacity: opacity,
                  child: AvifImage.network(
                    url,
                    fit: fit,
                    alignment: alignment,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(error);
                    },
                  ),
                );
              } else {
                return Opacity(
                  opacity: opacity,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: fit,
                    alignment: alignment,
                    placeholder: (context, url) {
                      final placeholderBuilder = _placeHolderBuilderCreator();
                      return placeholderBuilder != null
                          ? placeholderBuilder(context)
                          : const SizedBox.shrink();
                    },
                    errorWidget: (context, url, error) =>
                        _buildErrorWidget(error),
                  ),
                );
              }
            } else {
              // Non-web: Use file-based rendering (as before)
              final file = snapshot.data!.file;
              if (imageType == 'avif' || url.endsWith('.avif')) {
                return Opacity(
                  opacity: opacity,
                  child: AvifImage.file(
                    file,
                    fit: fit,
                    alignment: alignment,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(error);
                    },
                  ),
                );
              } else {
                return Opacity(
                  opacity: opacity,
                  child: Image.file(
                    file,
                    fit: fit,
                    alignment: alignment,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(error);
                    },
                  ),
                );
              }
            }
          },
        );
      }),
    );
  }
}
