import 'package:digia_ui/Utils/constants/images/images.dart';
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
    return Container(
      margin: _props.margins.margins(),
      padding: _props.margins.margins(),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.rectangle,
        borderRadius: _props.cornerRadius?.getRadius()
      ),
      height: _props.height,
      width: _props.width,
      child: _props.imageSrc.contains('http')
          ? Image(
              image: NetworkImage(_props.imageSrc),
              fit: _props.fit.fitImage(),
            )
          : Image(
              image: AssetImage(kDUIImagePath + _props.imageSrc),
              fit: _props.fit.fitImage(),
            ),
    );
  }
}
