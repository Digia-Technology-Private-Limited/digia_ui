import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../../components/dui_widget_scope.dart';
import '../../models/dui_file.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIImageBuilder extends DUIWidgetBuilder {
  DUIImageBuilder({required super.data});

  static DUIImageBuilder create(DUIWidgetJsonData data) {
    return DUIImageBuilder(data: data);
  }

  factory DUIImageBuilder.fromProps({required Map<String, dynamic>? props}) {
    return DUIImageBuilder(
        data: DUIWidgetJsonData(type: 'digia/image', props: props));
  }

  Future<ImageProvider> _createImageProvider(BuildContext context) async {
    final imageSource = eval(data.props['imageSrc'], context: context);

    if (imageSource is DUIFile) {
      if (imageSource.isWeb && imageSource.bytes != null) {
        // Use MemoryImage for web with bytes
        return MemoryImage(imageSource.bytes!);
      } else if (imageSource.isMobile && imageSource.path != null) {
        // Use FileImage for mobile with path
        return FileImage(File(imageSource.path!));
      } else {
        throw Exception('Invalid DUIFile source');
      }
    }

    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        // Network Image
        return CachedNetworkImageProvider(imageSource);
      } else {
        return DUIWidgetScope.maybeOf(context)
                ?.imageProviderFn
                ?.call(imageSource) ??
            AssetImage(imageSource);
      }
    }

    throw Exception('Unsupported image source type');
  }

  OctoPlaceholderBuilder? _placeHolderBuilderCreater() {
    Widget widget = Container(
      color: Colors.transparent,
    );

    final placeHolderValue = data.props['placeHolder'];

    if (placeHolderValue != null && placeHolderValue.isNotEmpty) {
      widget = switch (placeHolderValue.split('/').first) {
        'http' || 'https' => CachedNetworkImage(imageUrl: placeHolderValue),
        'assets' => Image.asset(placeHolderValue),
        'blurHash' => BlurHash(
            hash: placeHolderValue,
            duration: const Duration(
              microseconds: 0,
            )),
        _ => widget
      };
    }

    return (context) => _mayWrapInAspectRatio(widget);
  }

  _mayWrapInAspectRatio(Widget child) =>
      DUIAspectRatio(value: data.props['aspectRatio'], child: child);

  @override
  Widget build(BuildContext context) {
    final opacity =
        eval<double>(data.props['opacity'], context: context) ?? 1.0;

    return FutureBuilder<ImageProvider>(
      future: _createImageProvider(context),
      builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          );
        }

        final imageProvider = snapshot.data;

        return Opacity(
          opacity: opacity,
          child: imageProvider != null
              ? (imageProvider is MemoryImage || imageProvider is FileImage
                  ? Image(image: imageProvider)
                  : OctoImage(
                      fadeInDuration: const Duration(microseconds: 0),
                      fadeOutDuration: const Duration(microseconds: 0),
                      image: imageProvider,
                      fit: DUIDecoder.toBoxFit(data.props['fit']),
                      gaplessPlayback: true,
                      placeholderBuilder: _placeHolderBuilderCreater(),
                      imageBuilder: (BuildContext context, Widget widget) {
                        return _mayWrapInAspectRatio(widget);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        final errorImage = data.props['errorImage'];
                        if (errorImage == null) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                          );
                        }
                        return Image.asset(errorImage);
                      },
                    ))
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
