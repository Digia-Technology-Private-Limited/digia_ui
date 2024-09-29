import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../models/dui_file.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../utils/flutter_type_converters.dart';
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
      RenderPayload payload, Object? imageSource) {
    if (imageSource is List<DUIFile> && imageSource.isNotEmpty) {
      final firstFile = imageSource.first;
      if (firstFile.isWeb && firstFile.xFile?.path != null) {
        return CachedNetworkImageProvider(firstFile.xFile!.path);
      } else if (firstFile.isMobile && firstFile.path != null) {
        return FileImage(File(firstFile.path!));
      }
      throw Exception('Invalid DUIFile source in list');
    }

    if (imageSource is DUIFile) {
      if (imageSource.isWeb && imageSource.xFile?.path != null) {
        return CachedNetworkImageProvider(imageSource.xFile!.path);
      } else if (imageSource.isMobile && imageSource.path != null) {
        return FileImage(File(imageSource.path!));
      }
      throw Exception('Invalid DUIFile source');
    }

    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        return CachedNetworkImageProvider(imageSource);
      } else {
        return ResourceProvider.maybeOf(payload.buildContext)
                ?.getImageProvider(imageSource) ??
            AssetImage(imageSource);
      }
    }

    throw Exception('Unsupported image source type');
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreater() {
    Widget widget = Container(color: Colors.transparent);

    final placeHolderValue = props.getString('placeHolder');

    if (placeHolderValue != null && placeHolderValue.isNotEmpty) {
      widget = switch (placeHolderValue.split('/').first) {
        'http' || 'https' => CachedNetworkImage(imageUrl: placeHolderValue),
        'assets' => Image.asset(placeHolderValue),
        'blurHash' => BlurHash(
            hash: placeHolderValue,
            duration: const Duration(microseconds: 0),
          ),
        _ => widget
      };
    }

    return (context) => _mayWrapInAspectRatio(widget);
  }

  _mayWrapInAspectRatio(Widget child) =>
      wrapInAspectRatio(value: props.get('aspectRatio'), child: child);

  @override
  Widget render(RenderPayload payload) {
    final imageSource = payload.eval(props.get('imageSrc'));
    final opacity = payload.eval<double>(props.get('opacity')) ?? 1.0;

    final imageProvider = _createImageProvider(payload, imageSource);

    return Opacity(
      opacity: opacity,
      child: imageProvider is MemoryImage || imageProvider is FileImage
          ? Image(image: imageProvider)
          : OctoImage(
              fadeInDuration: const Duration(microseconds: 0),
              fadeOutDuration: const Duration(microseconds: 0),
              image: imageProvider,
              fit: To.boxFit(props.get('fit')),
              gaplessPlayback: true,
              placeholderBuilder: _placeHolderBuilderCreater(),
              imageBuilder: (BuildContext context, Widget widget) {
                return _mayWrapInAspectRatio(widget);
              },
              errorBuilder: (context, error, stackTrace) {
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
              },
            ),
    );
  }
}
