import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/core/container/dui_container.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../dui_widget.dart';

class DUIImage extends StatelessWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  OctoPlaceholderBuilder? _placeHolderBuilderCreater() {
    final placeHolderValue = props.placeHolder;

    if (placeHolderValue == null || placeHolderValue.isEmpty) {
      return null;
    }

    switch (props.imageSrc.split('/').first) {
      case 'http':
      case 'https':
        return ((context) => CachedNetworkImage(imageUrl: placeHolderValue));
      case 'assets':
        return ((context) => Image.asset(placeHolderValue));
      case 'blurHash':
        return OctoPlaceholder.frame(); // [TODO] : This had been changed
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;
    // Network Image
    if (props.imageSrc.startsWith('http')) {
      imageProvider = CachedNetworkImageProvider(props.imageSrc);
    } else {
      imageProvider =
          DUIWidgetScope.of(context)?.imageProviderFn?.call(props.imageSrc) ??
              AssetImage(props.imageSrc);
    }

    return OctoImage(
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
            return const Icon(Icons.error);
          }
          return Image.asset(props.errorImage!);
        });
  }
}
