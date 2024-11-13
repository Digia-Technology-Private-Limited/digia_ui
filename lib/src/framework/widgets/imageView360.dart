import 'package:flutter/widgets.dart';
import 'package:imageview360/imageview360.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../widget_props/image_view_360_props.dart';

class VWImageView360 extends VirtualStatelessWidget<ImageView360Props> {
  VWImageView360({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    RotationDirection getRotationDirection() {
      switch (payload.evalExpr<String>(props.rotationDirection)) {
        case 'clockwise':
          return RotationDirection.clockwise;
        case 'anticlockwise':
          return RotationDirection.anticlockwise;
        default:
          return RotationDirection.clockwise;
      }
    }

    final imageUrlList =
        payload.evalExpr<List<String>>(props.imageUrlList)?.map((e) {
              return NetworkImage(e);
            }).toList() ??
            [];
    return ImageView360(
      key: UniqueKey(),
      imageList: imageUrlList,
      allowSwipeToRotate:
          payload.evalExpr<bool>(props.allowSwipeToRotate) ?? true,
      autoRotate: payload.evalExpr<bool>(props.autoRotate) ?? false,
      swipeSensitivity: payload.evalExpr<int>(props.swipeSensitivity) ?? 1,
      frameChangeDuration: Duration(
          milliseconds: payload.evalExpr<int>(props.frameChangeDuration) ?? 80),
      rotationDirection: getRotationDirection(),
    );
  }
}
