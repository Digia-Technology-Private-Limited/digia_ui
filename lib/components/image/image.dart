import 'package:digia_ui/Utils/constants.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/image/dui_cached_image.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:flutter/material.dart';

class DUIImage extends StatefulWidget {
  final DUIImageProps props;

  const DUIImage(this.props, {super.key}) : super();

  factory DUIImage.fromJson(Map<String, dynamic> json) =>
      DUIImage(DUIImageProps.fromJson(json));

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

  Widget errorImage() => Image.asset(
        duiErrorImage,
        height: props.height,
        width: props.width,
        fit: toBoxFit(props.fit),
      );

  Widget placeHolderImage() => Image.asset(
        duiPlaceHolder,
        height: props.height,
        width: props.width,
        fit: toBoxFit(props.fit),
      );

  Widget assetImage() => Image.asset(
        props.imageSrc,
        height: props.height,
        width: props.width,
        fit: toBoxFit(props.fit),
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return errorImage();
        },
      );

  Widget cachedImage() => DUICachedImage(
        width: props.width,
        height: props.height,
        fit: toBoxFit(props.fit),
        borderRadius: toBorderRadiusGeometry(props.cornerRadius),
        imageUrl: props.imageSrc,
        errorImage: errorImage(),
        placeHolderImage: placeHolderImage(),
      );

  Widget imageWidget() => ClipRRect(
      borderRadius: toBorderRadiusGeometry(props.cornerRadius),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: toEdgeInsetsGeometry(props.padding),
        child: props.imageSrc.split('/').first == 'assets'
            ? assetImage()
            : cachedImage(),
      ));

  @override
  Widget build(BuildContext context) {
    if (props.margin == null) {
      return imageWidget();
    }

    return Padding(
      padding: toEdgeInsetsGeometry(props.margin),
      child: imageWidget(),
    );
  }
}
