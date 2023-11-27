import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/dui_avatar/avatar_props.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:digia_ui/components/image/image.props.dart';
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
      AvatarShape.circle => _getCircleAvatar(),
      AvatarShape.square => _getSquareAvatar()
    };
  }

  Widget _getCircleAvatar() {
    return Container(
      height: widget.props.radius * 2,
      width: widget.props.radius * 2,
      decoration: BoxDecoration(
        color: widget.props.bgColor?.let(toColor) ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(),
    );
  }

  Widget _getSquareAvatar() {
    return Container(
      height: widget.props.side,
      width: widget.props.side,
      decoration: BoxDecoration(
          color: widget.props.bgColor?.let(toColor) ?? Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius:
              DUIDecoder.toBorderRadius(widget.props.cornerRadius?.toJson())),
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
