import 'package:digia_ui/Utils/constants.dart';
import 'package:digia_ui/components/image/dui_cached_image.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:flutter/material.dart';

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

  Widget errorImage() => Image.asset(
        duiErrorImage,
        height: props.height,
        width: props.width,
        fit: props.fit.getFit(),
      );

  Widget placeHolderImage() => Image.asset(
        duiPlaceHolder,
        height: props.height,
        width: props.width,
        fit: props.fit.getFit(),
      );

  Widget imageWidget() => ClipRRect(
        borderRadius: props.cornerRadius?.getCornerRadius(),
        clipBehavior: Clip.antiAlias,
        child: props.imageSrc.split('/').first == 'assets'
            ? Image.asset(
                props.imageSrc,
                height: props.height,
                width: props.width,
                fit: props.fit.getFit(),
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return errorImage();
                },
              )
            : DUICachedImage(
                width: props.width,
                height: props.height,
                fit: props.fit.getFit(),
                borderRadius: props.cornerRadius?.getCornerRadius(),
                imageUrl: props.imageSrc,
                errorImage: errorImage(),
                placeHolderImage: placeHolderImage(),
              ),
      );

  @override
  Widget build(BuildContext context) {
    return props.margins != null
        ? Padding(
            padding: props.margins!.getInsets(),
            child: imageWidget(),
          )
        : imageWidget();
  }
}
