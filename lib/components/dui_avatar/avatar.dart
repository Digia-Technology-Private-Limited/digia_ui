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
        return makeStandardAvatar();
    }
  }

  Widget makeStandardAvatar() {
    return CircleAvatar(
      backgroundColor: widget.duiAvatarProps.backgroundColor,
      radius: widget.duiAvatarProps.radius,
      child: _getAvatarChildWidget(),
    );
  }

  Widget makeSquareAvatar() {
    return SizedBox(
      height: _duiAvatarProps.radius,
      width: _duiAvatarProps.radius,
      child: _getAvatarChildWidget(),
    );
  }

  Widget _getAvatarChildWidget() {
    if (_duiAvatarProps.image != null) {
      // [TODO]: SHOW IMAGE
      return Container();
    } else {
      // [TODO]: SHOW FALLBACK TEXT
      return Container();
    }
  }
}
