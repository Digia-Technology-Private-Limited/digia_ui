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
      'circle' => _buildCircle(shapeProps, payload),
      'square' => _buildSquare(shapeProps, payload),
      _ => _buildCircle(shapeProps, payload),
    };
  }

  Widget _buildCircle(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor')) ?? Colors.grey;
    final radius = payload.eval<double>(shapeProps?.get('radius')) ?? 12; // sync with CWAvatar
    final diameter = radius * 2;
    return ClipOval(
      child: Container(
        width: diameter,
        height: diameter,
        color: bgColor,
        child: _buildChild(payload, diameter, diameter, isCircle: true),
      ),
    );
  }

  Widget _buildSquare(Props? shapeProps, RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor')) ?? Colors.grey;
    final cornerRadius = To.borderRadius(shapeProps?.get('cornerRadius'));
    final side = payload.eval<double>(shapeProps?.get('side')) ?? 16;
    return ClipRRect(
      borderRadius: cornerRadius ?? BorderRadius.zero,
      child: Container(
        width: side,
        height: side,
        color: bgColor,
        child: _buildChild(payload, side, side, isCircle: false),
      ),
    );
  }

  Widget _buildChild(RenderPayload payload, double w, double h,
      {required bool isCircle}) {
    final childType = props.getString('_childType'); // sync logic
    final imagePropsMap = props.getMap('image');

    if (childType == 'image' && imagePropsMap != null) {
      final fit = To.boxFit(imagePropsMap['fit']);
      // Prefer explicit image.src.imageSrc expr if present
      final imageSrcExpr =
          props.get('image.src.imageSrc') ?? imagePropsMap['imageSrc'];
      final imageSrc = payload.eval(imageSrcExpr);

      if (imageSrc is String && imageSrc.isNotEmpty) {
        final vwImage = VWImage(
          props: Props({
            ...imagePropsMap,
            'imageSrc': imageSrc,
            'fit': imagePropsMap['fit'],
            'width': w,
            'height': h,
          }),
          commonProps: null,
          parent: null,
        );
        return SizedBox(
          width: w,
          height: h,
          child: FittedBox(
            fit: fit,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: w,
              height: h,
              child: vwImage.toWidget(payload),
            ),
          ),
        );
      }
    }

    return SizedBox(
      width: w,
      height: h,
      child: Center(
        child: VWText(
          props:
              props.getMap('text').maybe(TextProps.fromJson) ?? TextProps(),
          commonProps: null,
          parent: null,
        ).toWidget(payload),
      ),
    );
  }
}
