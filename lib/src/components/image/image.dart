import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/core/container/dui_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';

class DUIImage extends StatefulWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIImageState();
}

class _DUIImageState extends State<DUIImage> {
  late DUIImageProps props;

  _DUIImageState();

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

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
      imageProvider = AssetImage(props.imageSrc);
    }

    return OctoImage(
        fadeInDuration: const Duration(microseconds: 0),
        fadeOutDuration: const Duration(microseconds: 0),
        image: imageProvider,
        fit: DUIDecoder.toBoxFit(props.fit),
        gaplessPlayback: true,
        placeholderBuilder: _placeHolderBuilderCreater(),
        imageBuilder: (BuildContext context, Widget widget) {
          final child = props.aspectRatio == null
              ? Opacity(opacity: props.opacity ?? 1, child: widget)
              : AspectRatio(
                  aspectRatio: props.aspectRatio!,
                  child: Opacity(opacity: props.opacity ?? 1, child: widget));
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
        });
  }
}
