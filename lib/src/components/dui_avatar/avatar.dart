import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/dui_avatar/avatar_props.dart';
import 'package:digia_ui/src/components/image/image.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:flutter/material.dart';

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
