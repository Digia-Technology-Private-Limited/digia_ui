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
    return switch (shapeProps?.get('value')) {
      'circle' => _getCircleAvatar(shapeProps, payload),
      'square' => _getSquareAvatar(shapeProps, payload),
      _ => _getCircleAvatar(shapeProps, payload),
    };
  }

  Widget _getCircleAvatar(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor')) ?? Colors.grey;
    final radius = payload.eval<double>(shapeProps?.get('radius')) ?? 12;
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: ClipOval(
        child: _getAvatarChildWidget(payload, radius * 2, radius * 2),
      ),
    );
  }

  Widget _getSquareAvatar(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor')) ?? Colors.grey;
    final cornerRadius = To.borderRadius(shapeProps?.get('cornerRadius'));
    final side = payload.eval<double>(shapeProps?.get('side')) ?? 16;

    return ClipRRect(
      borderRadius: cornerRadius,
      child: Container(
        width: side,
        height: side,
        color: bgColor,
        child: _getAvatarChildWidget(payload, side, side),
      ),
    );
  }

  // Rendering logic synchronized with CWAvatar. Data fetching lines kept intact.
  Widget _getAvatarChildWidget(RenderPayload payload, double w, double h) {
    final imageProps = props.getMap('image');
    final String? imageSrc = payload
        .eval(props.get('image.src.imageSrc') ?? imageProps?['imageSrc']);
    final String? imageFit = payload.eval(imageProps?['fit']);

    if (imageSrc != null && imageSrc.isNotEmpty) {
      return SizedBox(
        width: w,
        height: h,
        child: FittedBox(
          fit: To.boxFit(imageFit),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: w,
            height: h,
            child: VWImage.fromValues(
              imageSrc: imageSrc,
              imageFit: imageFit,
            ).toWidget(payload),
          ),
        ),
      );
    }

    return SizedBox(
      width: w,
      height: h,
      child: Center(
        child: VWText(
          props: props.getMap('text').maybe(TextProps.fromJson) ?? TextProps(),
          commonProps: null,
          parent: null,
        ).toWidget(payload),
      ),
    );
  }
}
