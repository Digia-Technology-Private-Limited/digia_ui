import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../digia_ui_client.dart';
import '../../dui_dev_config.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../data_type/adapted_types/file.dart';
import '../expr/default_scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/widget_util.dart';

class VWImage extends VirtualLeafStatelessWidget<Props> {
  VWImage({
    required super.props,
    required super.commonProps,
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
        final DigiaUIHost? host = DigiaUIClient.instance.developerConfig?.host;
        final String finalUrl;
        if (host is DashboardHost && host.resourceProxyUrl != null) {
          finalUrl = '${host.resourceProxyUrl}$imageSource';
        } else {
          finalUrl = imageSource;
        }
        return CachedNetworkImageProvider(
          finalUrl,
          maxHeight: maxHeight.maybe((it) => it * dpr),
          maxWidth: maxWidth.maybe((it) => it * dpr),
        );
      } else {
        return ResourceProvider.maybeOf(payload.buildContext)
                ?.getImageProvider(imageSource) ??
            AssetImage(imageSource);
      }
    }

    throw Exception('Unsupported image source type');
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreator() {
    Widget widget = Container(color: Colors.transparent);

    final placeHolderValue = props.getString('placeHolder');

    if (placeHolderValue != null && placeHolderValue.isNotEmpty) {
      widget = switch (placeHolderValue.split('/').first) {
        'http' ||
        'https' =>
          Image(image: CachedNetworkImageProvider(placeHolderValue)),
        'assets' => Image.asset(placeHolderValue),
        'blurHash' => BlurHash(
            hash: placeHolderValue,
            duration: const Duration(microseconds: 0),
          ),
        _ => widget
      };
    }

    return (context) => widget;
  }

  Widget _buildErrorWidget(Object error) {
    final errorImage = props.getString('errorImage');
    if (errorImage == null) {
      return Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
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

        final imageProvider = _createImageProvider(
          payload,
          imageSource,
          maxHeight,
          maxWidth,
          dpr,
        );

        if ((imageSource as String).contains('.avif')) {
          return Opacity(
            opacity: opacity,
            child: AvifImage(
              image: imageProvider,
              fit: To.boxFit(props.get('fit')),
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
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorWidget(error);
                  },
                )
              : OctoImage(
                  fadeInDuration: const Duration(microseconds: 0),
                  fadeOutDuration: const Duration(microseconds: 0),
                  image: imageProvider,
                  fit: To.boxFit(props.get('fit')),
                  gaplessPlayback: true,
                  placeholderBuilder: _placeHolderBuilderCreator(),
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorWidget(error);
                  }),
        );
      }),
    );
  }
}
