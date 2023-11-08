import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/dui_avatar/avatar_props.dart';
import 'package:flutter/material.dart';

class DUIAvatar extends StatefulWidget {
  final DUIAvatarProps duiAvatarProps;
  const DUIAvatar({required this.duiAvatarProps, super.key});

  @override
  State<DUIAvatar> createState() => _DUIAvatarState();
}

class _DUIAvatarState extends State<DUIAvatar> {
  late final DUIAvatarProps _duiAvatarProps;

  @override
  void initState() {
    _duiAvatarProps = widget.duiAvatarProps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_duiAvatarProps.shape) {
      case AvatarShape.square:
        return makeSquareAvatar();
      default:
        return makeCircleAvatar();
    }
  }

  Widget makeCircleAvatar() {
    return CircleAvatar(
      backgroundColor: _duiAvatarProps.bgColor != null
          ? ColorDecoder.fromString(_duiAvatarProps.bgColor)
          : Colors.yellow,
      // radius: _duiAvatarProps.radius.,
      child: _getAvatarChildWidget(),
    );
  }

  Widget makeSquareAvatar() {
    return Container(
      height: _duiAvatarProps.radius!.topLeft * 10,
      width: _duiAvatarProps.radius!.bottomLeft * 2,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: _duiAvatarProps.radius != null
            ? BorderRadius.only(
                topLeft: Radius.circular(_duiAvatarProps.radius!.topLeft),
                topRight: Radius.circular(_duiAvatarProps.radius!.topRight),
                bottomLeft: Radius.circular(_duiAvatarProps.radius!.bottomLeft),
                bottomRight:
                    Radius.circular(_duiAvatarProps.radius!.bottomRight),
              )
            : BorderRadius.zero,
      ),
      child: SizedBox(
          height: _duiAvatarProps.radius!.topLeft * 10,
          width: _duiAvatarProps.radius!.bottomLeft * 2,
          child: _getAvatarChildWidget()),
    );
  }

  Widget _getAvatarChildWidget() {
    if (_duiAvatarProps.imageSrc != null) {
      // [TODO]: SHOW IMAGE
      return Container();
    } else {
      // SHOW DUIText FALLBACK
      return DUIText(_duiAvatarProps.fallbackText!);
    }
  }
}
