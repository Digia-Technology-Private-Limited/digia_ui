import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
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
    final shape = props['shape'];

    return switch (shape['value']) {
      'circle' => _getCircleAvatar(shape, payload),
      'square' => _getSquareAvatar(shape, payload),
      _ => _getCircleAvatar(shape, payload)
    };
  }

  Widget _getCircleAvatar(Map<String, dynamic> shape, RenderPayload payload) {
    final bgColor = payload.eval<String>(props['bgColor']);
    final radius = payload.eval<double>(shape['radius']);
    return Container(
      height: (radius ?? 16) * 2,
      width: (radius ?? 16) * 2,
      decoration: BoxDecoration(
        color: makeColor(bgColor) ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(payload),
    );
  }

  Widget _getSquareAvatar(Map<String, dynamic> shape, RenderPayload payload) {
    final String? bgColor = payload.eval<String>(props['bgColor']);
    final String? cornerRadius = shape['cornerRadius'];
    final double? side = payload.eval<double>(shape['side']);

    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
          color: makeColor(bgColor) ?? Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius: DUIDecoder.toBorderRadius(cornerRadius)),
      clipBehavior: Clip.hardEdge,
      child: _getAvatarChildWidget(payload),
    );
  }

  Widget? _getAvatarChildWidget(RenderPayload payload) {
    final String? imageSrc = payload.eval<String>(props['imageSrc']);
    final String? imageFit = payload.eval<String>(props['imageFit']);

    if (imageSrc != null) {
      return VWImage(
        props: {'imageSrc': imageSrc, 'fit': imageFit},
        commonProps: commonProps,
        parent: this,
      ).render(payload);
    }
    return Align(
      alignment: Alignment.center,
      child: VWText(
        props: props['text'] as Map<String, dynamic>,
        commonProps: commonProps,
        parent: this,
      ).render(payload),
    );
  }
}
