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
        // return CachedNetworkImageProvider(firstFile.xFile!.path);
        return NetworkImage(firstFile.xFile!.path);
      } else if (firstFile.isMobile && firstFile.path != null) {
        return FileImage(File(firstFile.path!));
      }
      throw Exception('Invalid File source in list');
    }

    if (imageSource is AdaptedFile) {
      if (imageSource.isWeb && imageSource.xFile?.path != null) {
        // return CachedNetworkImageProvider(imageSource.xFile!.path);
        return NetworkImage(imageSource.xFile!.path);
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
        // return CachedNetworkImageProvider(finalUrl);
        return NetworkImage(finalUrl);
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
            duration: const Duration(milliseconds: 300),
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

        if (imageType == 'svg' ||
            (imageSource is String && hasExtension(imageSource, ['.svg']))) {
          return _buildSvgImage(imageSource, payload, opacity);
        }

        final imageProvider = _createImageProvider(
          payload,
          imageSource,
          maxHeight,
          maxWidth,
          dpr,
        );

        if (imageType == 'avif' ||
            (imageSource is String && hasExtension(imageSource, ['.avif']))) {
          return Opacity(
            opacity: opacity,
            child: AvifImage(
              image: imageProvider,
              fit: To.boxFit(props.get('fit')),
              alignment:
                  To.alignment(props.get('alignment')) ?? Alignment.center,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget(error);
              },
            ),
          );
        }
        return Opacity(
          opacity: opacity,
          child: imageProvider is MemoryImage || imageProvider is FileImage
              ? Image(
                  image: imageProvider,
                  fit: To.boxFit(props.get('fit')),
                  alignment:
                      To.alignment(props.get('alignment')) ?? Alignment.center,
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
                  fit: To.boxFit(props.get('fit')),
                  gaplessPlayback: true,
                  placeholderBuilder: _placeHolderBuilderCreator(),
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorWidget(error);
                  },
                  alignment:
                      To.alignment(props.get('alignment')) ?? Alignment.center,
                ),
        );
      }),
    );
  }
}
