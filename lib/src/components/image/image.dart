import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../core/container/dui_container.dart';
import '../dui_widget_scope.dart';
import 'image.props.dart';

class DUIImage extends StatelessWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  OctoPlaceholderBuilder? _placeHolderBuilderCreater() {
    Widget widget = Container(
      color: Colors.grey.shade50,
    );

    final placeHolderValue = props.placeHolder;

    if (placeHolderValue != null && placeHolderValue.isNotEmpty) {
      widget = switch (placeHolderValue.split('/').first) {
        'http' || 'https' => CachedNetworkImage(imageUrl: placeHolderValue),
        'assets' => Image.asset(placeHolderValue),
        'blurHash' => BlurHash(
            hash: props.placeHolder!,
            duration: const Duration(
              microseconds: 0,
            )),
        _ => widget
      };
    }

    if (props.aspectRatio != null) {
      widget = AspectRatio(aspectRatio: props.aspectRatio!, child: widget);
    }

    return (context) => widget;
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;
    // Network Image
    if (props.imageSrc.startsWith('http')) {
      imageProvider = CachedNetworkImageProvider(props.imageSrc);
    } else {
      imageProvider = DUIWidgetScope.maybeOf(context)
              ?.imageProviderFn
              ?.call(props.imageSrc) ??
          AssetImage(props.imageSrc);
    }

    return Opacity(
      opacity: props.opacity ?? 1,
      child: OctoImage(
          fadeInDuration: const Duration(microseconds: 0),
          fadeOutDuration: const Duration(microseconds: 0),
          image: imageProvider,
          fit: DUIDecoder.toBoxFit(props.fit),
          gaplessPlayback: true,
          placeholderBuilder: _placeHolderBuilderCreater(),
          imageBuilder: (BuildContext context, Widget widget) {
            final child = props.aspectRatio == null
                ? widget
                : AspectRatio(aspectRatio: props.aspectRatio!, child: widget);
            return props.styleClass != null
                ? DUIContainer(styleClass: props.styleClass, child: child)
                : child;
          },
          errorBuilder: (context, error, stackTrace) {
            if (props.errorImage == null) {
              return const Icon(
                Icons.error_outline,
                color: Colors.red,
              );
            }
            return Image.asset(props.errorImage!);
          }),
    );
  }
}
