import 'package:digia_ui/components/image/image.props.dart';
import 'package:flutter/material.dart';

class DUIImage extends StatefulWidget {
  final DUIImageProps _props;

  const DUIImage(this._props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIImageState(_props);
}

class _DUIImageState extends State<DUIImage> {
  final DUIImageProps _props;
  _DUIImageState(this._props);

  @override
  Widget build(BuildContext context) {
    return Image(
      height: _props.height,
      width: _props.width,
      image: const NetworkImage(""),
    );
  }
}
