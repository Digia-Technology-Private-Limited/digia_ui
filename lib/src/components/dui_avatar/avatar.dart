import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../DUIText/dui_text.dart';
import '../image/image.dart';
import '../image/image.props.dart';
import '../utils/DUICornerRadius/dui_corner_radius.dart';
import 'avatar_props.dart';

class DUIAvatar extends StatefulWidget {
  final DUIAvatarProps props;
  const DUIAvatar({required this.props, super.key});

  @override
  State<DUIAvatar> createState() => _DUIAvatarState();
}

class _DUIAvatarState extends State<DUIAvatar> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.props.shape) {
      AvatarCircleShape(:final radius) => _getCircleAvatar(radius),
      AvatarSquareShape(:final sideLength, :final cornerRadius) =>
        _getSquareAvatar(sideLength, cornerRadius),
      _ => _getCircleAvatar(16.0)
    };
  }

  Widget _getCircleAvatar(double radius) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        color: widget.props.bgColor?.let(toColor) ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(),
    );
  }

  Widget _getSquareAvatar(double side, DUICornerRadius? cornerRadius) {
    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
          color: widget.props.bgColor?.let(toColor) ?? Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius: DUIDecoder.toBorderRadius(cornerRadius?.toJson())),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(),
    );
  }

  Widget? _getAvatarChildWidget() {
    if (widget.props.imageSrc != null) {
      return DUIImage(DUIImageProps(
          imageSrc: widget.props.imageSrc!, fit: widget.props.imageFit));
    }

    return widget.props.text.let((p0) => Align(
          alignment: Alignment.center,
          child: DUIText(p0),
        ));
  }
}
