import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'image.dart';
import 'text.dart';

class VWAvatar extends VirtualLeafStatelessWidget {
  VWAvatar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final shape = props.toProps('shape');

    if (shape == null) return empty();

    return switch (shape.get('value')) {
      'circle' => _getCircleAvatar(shape, payload),
      'square' => _getSquareAvatar(shape, payload),
      _ => _getCircleAvatar(shape, payload)
    };
  }

  Widget _getCircleAvatar(Props shape, RenderPayload payload) {
    final bgColor = payload.eval<String>(props.get('bgColor'));
    final radius = payload.eval<double>(shape.get('radius'));
    return CircleAvatar(
      radius: radius ?? 16,
      backgroundColor: makeColor(bgColor) ?? Colors.grey,
      child: _getAvatarChildWidget(payload),
    );
  }

  Widget _getSquareAvatar(Props shape, RenderPayload payload) {
    final bgColor = payload.eval<String>(props.get('bgColor'));
    final cornerRadius = DUIDecoder.toBorderRadius(shape.get('cornerRadius'));
    final side = payload.eval<double>(shape.get('side'));

    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
          color: makeColor(bgColor) ?? Colors.grey,
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
        props: props.toProps('text') ?? Props.empty(),
        commonProps: null,
        parent: null,
      ).toWidget(payload),
    );
  }
}
