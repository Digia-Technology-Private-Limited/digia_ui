import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';
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
        // TODO: Add blurHash functionality back
        return OctoPlaceholder.frame();
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
      imageProvider = AssetImage(props.imageSrc);
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
