import 'package:digia_ui/Utils/constants/constants.dart';
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

  Widget imageWidget() => props.imageSrc.split('/').first == 'assets'
      ? Image.asset(props.imageSrc, fit: props.fit.fitImage(), errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset(
            kDUIErrorImage,
            fit: props.fit.fitImage(),
          );
        })
      : Image.network(
          props.imageSrc,
          fit: props.fit.fitImage(),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Image.asset(
              kDUIPlaceHolder,
              fit: props.fit.fitImage(),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(
              kDUIErrorImage,
              fit: props.fit.fitImage(),
            );
          },
        );

  @override
  Widget build(BuildContext context) {
    return props.margins != null
        ? Container(
            margin: props.margins!.margins(),
            padding: props.margins!.margins(),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.rectangle,
                borderRadius: props.cornerRadius?.getRadius()),
            height: props.height,
            width: props.width,
            child: imageWidget(),
          )
        : imageWidget();
  }
}
