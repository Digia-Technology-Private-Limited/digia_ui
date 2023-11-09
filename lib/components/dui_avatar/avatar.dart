import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/dui_avatar/avatar_props.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:digia_ui/components/image/image.props.dart';
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
    return _getAvatar();
    switch (_duiAvatarProps.shape) {
      case AvatarShape.square:
        return makeSquareAvatar();
      default:
        return makeCircleAvatar();
    }
  }

  Widget _getAvatar() {
    return Container(
      height: _getSize(),
      width: _getSize(),
      decoration: BoxDecoration(
        color: _duiAvatarProps.bgColor != null
            ? ColorDecoder.fromString(_duiAvatarProps.bgColor)
            : Colors.yellow,
        shape: _getBoxShape(),
        borderRadius: _duiAvatarProps.shape != AvatarShape.circle &&
                _duiAvatarProps.cornerRadius != null
            ? BorderRadius.only(
                topLeft: Radius.circular(_duiAvatarProps.cornerRadius!.topLeft),
                topRight:
                    Radius.circular(_duiAvatarProps.cornerRadius!.topRight),
                bottomLeft:
                    Radius.circular(_duiAvatarProps.cornerRadius!.bottomLeft),
                bottomRight:
                    Radius.circular(_duiAvatarProps.cornerRadius!.bottomRight),
              )
            : null,
        image: _duiAvatarProps.imageSrc != null
            ? DecorationImage(
                image: NetworkImage(
                  _duiAvatarProps.imageSrc!,
                ),
              )
            : null,
      ),
      child: _duiAvatarProps.imageSrc != null
          ? DUIImage(
              DUIImageProps(
                imageSrc: _duiAvatarProps.imageSrc!,
                fit: _duiAvatarProps.imageFit,
              ),
            )
          : DUIText(_duiAvatarProps.fallbackText!),
    );
  }

  BoxShape _getBoxShape() {
    switch (_duiAvatarProps.shape) {
      case AvatarShape.circle:
        return BoxShape.circle;
      default:
        return BoxShape.rectangle;
    }
  }

  double _getSize() {
    switch (_duiAvatarProps.shape) {
      case AvatarShape.circle:
        return _duiAvatarProps.radius * 2;
      default:
        return _duiAvatarProps.side;
    }
  }

  Widget makeCircleAvatar() {
    return CircleAvatar(
      backgroundColor: _duiAvatarProps.bgColor != null
          ? ColorDecoder.fromString(_duiAvatarProps.bgColor)
          : Colors.yellow, // [TODO]: CHOOSE DEFAULT COLOR
      radius: _duiAvatarProps.radius, // [TODO]: GET RADIUS
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_duiAvatarProps.radius),
        child: _getAvatarChildWidget(),
      ),
    );
  }

  Widget makeSquareAvatar() {
    return Container(
      alignment: Alignment.center,
      height: _duiAvatarProps.side * 2, // [TODO]: GET HEIGHT AND WIDTH
      width: _duiAvatarProps.side * 2,
      decoration: BoxDecoration(
        color: _duiAvatarProps.bgColor != null
            ? ColorDecoder.fromString(_duiAvatarProps.bgColor)
            : Colors.yellow,
        borderRadius: _duiAvatarProps.cornerRadius != null
            ? BorderRadius.only(
                topLeft: Radius.circular(_duiAvatarProps.cornerRadius!.topLeft),
                topRight:
                    Radius.circular(_duiAvatarProps.cornerRadius!.topRight),
                bottomLeft:
                    Radius.circular(_duiAvatarProps.cornerRadius!.bottomLeft),
                bottomRight:
                    Radius.circular(_duiAvatarProps.cornerRadius!.bottomRight),
              )
            : BorderRadius.zero,
      ),
      child: ClipRRect(
        child: _getAvatarChildWidget(),
      ),
    );
  }

  Widget _getAvatarChildWidget() {
    // return DUIText(_duiAvatarProps.fallbackText!);

    if (_duiAvatarProps.imageSrc != null) {
      // SHOW DUIIMAGE
      return DUIImage(
        DUIImageProps(
          imageSrc: _duiAvatarProps.imageSrc!,
          fit: _duiAvatarProps.imageFit,
        ),
      );
    } else {
      // SHOW DUIText FALLBACK
      // print("fallbacktext: ${_duiAvatarProps.fallbackText}");
      return DUIText(_duiAvatarProps.fallbackText!);
    }
  }
}
