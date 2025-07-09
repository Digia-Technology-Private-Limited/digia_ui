import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../widget_props/text_props.dart';
import 'image.dart';
import 'text.dart';

class VWAvatar extends VirtualLeafStatelessWidget<Props> {
  VWAvatar({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final shapeProps = props.toProps('shape');

    // if (shapeProps == null) return empty();

    return switch (shapeProps?.get('value')) {
      'circle' => _getCircleAvatar(shapeProps, payload),
      'square' => _getSquareAvatar(shapeProps, payload),
      _ => _getCircleAvatar(shapeProps, payload)
    };
  }

  Widget _getCircleAvatar(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor'));
    final radius = payload.eval<double>(shapeProps?.get('radius'));
    return CircleAvatar(
      radius: radius ?? 16,
      backgroundColor: bgColor ?? Colors.grey,
      child: _getAvatarChildWidget(payload),
    );
  }

  Widget _getSquareAvatar(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor'));
    final cornerRadius = To.borderRadius(shapeProps?.get('cornerRadius'));
    final side = payload.eval<double>(shapeProps?.get('side'));

    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
          color: bgColor ?? Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius: cornerRadius),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(payload),
    );
  }

  Widget? _getAvatarChildWidget(RenderPayload payload) {
    final String? imageSrc = payload.eval<String>(props.get('imageSrc'));
    final String? imageFit = payload.eval<String>(props.get('imageFit'));

    if (imageSrc != null) {
      return VWImage.fromValues(
        imageSrc: imageSrc,
        imageFit: imageFit,
      ).toWidget(payload);
    }
    return Align(
      alignment: Alignment.center,
      child: VWText(
        props: props.getMap('text').maybe(TextProps.fromJson) ?? TextProps(),
        commonProps: null,
        parent: null,
      ).toWidget(payload),
    );
  }
}
