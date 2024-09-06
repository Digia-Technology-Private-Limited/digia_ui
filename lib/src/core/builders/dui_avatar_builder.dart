import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_image_builder.dart';
import 'dui_text_builder.dart';

class DUIAvatarBuilder extends DUIWidgetBuilder {
  DUIAvatarBuilder({required super.data});

  static DUIAvatarBuilder create(DUIWidgetJsonData data) {
    return DUIAvatarBuilder(data: data);
  }

  factory DUIAvatarBuilder.fromProps(Map<String, dynamic> props) {
    return DUIAvatarBuilder(
      data: DUIWidgetJsonData(type: 'digia/avatar', props: props),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = data.props['shape'];

    return switch (shape['value']) {
      'circle' => _getCircleAvatar(shape, context),
      'square' => _getSquareAvatar(shape, context),
      _ => _getCircleAvatar(shape, context)
    };
  }

  Widget _getCircleAvatar(Map<String, dynamic> shape, BuildContext context) {
    final bgColor = eval<String>(data.props['bgColor'], context: context);
    final radius = eval<double>(shape['radius'], context: context);
    print(radius);
    return Container(
      height: (radius ?? 16) * 2,
      width: (radius ?? 16) * 2,
      decoration: BoxDecoration(
        color: makeColor(bgColor) ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(context),
    );
  }

  Widget _getSquareAvatar(Map<String, dynamic> shape, BuildContext context) {
    final String? bgColor =
        eval<String>(data.props['bgColor'], context: context);
    final String? cornerRadius = shape['cornerRadius'];
    final double? side = eval<double>(shape['side'], context: context);

    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
          color: makeColor(bgColor) ?? Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius: DUIDecoder.toBorderRadius(cornerRadius)),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(context),
    );
  }

  Widget? _getAvatarChildWidget(BuildContext context) {
    final String? imageSrc =
        eval<String>(data.props['imageSrc'], context: context);
    final String? imageFit =
        eval<String>(data.props['imageFit'], context: context);

    if (imageSrc != null) {
      return DUIImageBuilder.fromProps(
          props: {'imageSrc': imageSrc, 'fit': imageFit}).build(context);
    }
    return Align(
        alignment: Alignment.center,
        child: DUITextBuilder.fromProps(
                props: data.props['text'] as Map<String, dynamic>?)
            .build(context));
  }
}
