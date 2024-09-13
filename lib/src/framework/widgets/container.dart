import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/basic_shared_utils/types.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../components/border/box_border_with_pattern/border_with_pattern.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWContainer extends VirtualStatelessWidget {
  VWContainer({
    required super.props,
    super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final width = props.string('width')?.toWidth(payload.buildContext);

    final height = props.string('height')?.toHeight(payload.buildContext);

    final borderRadius = DUIDecoder.toBorderRadius(
        props.valueFor(keyPath: 'border.borderRadius'));

    final alignment = DUIDecoder.toAlignment(props['childAlignment']);
    final margin = DUIDecoder.toEdgeInsets(props['margin']);
    final padding = DUIDecoder.toEdgeInsets(props['padding']);
    final color = makeColor(payload.eval<String>(props['color']));

    BoxShape shape =
        props['shape'] == 'circle' ? BoxShape.circle : BoxShape.rectangle;
    final gradiant = toGradiant(props['gradiant'], payload.buildContext);
    final elevation = props['elevation'] ?? 0.0;

    Widget container = Container(
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            gradient: gradiant,
            color: color,
            border: _toBorderWithPattern(payload, props['border']),
            borderRadius: shape == BoxShape.circle ? null : borderRadius,
            image: _toDecorationImage(payload, props['decorationImage']),
            shape: shape),
        constraints: BoxConstraints(
            maxHeight:
                props.string('maxHeight')?.toHeight(payload.buildContext) ??
                    double.infinity,
            maxWidth: props.string('maxWidth')?.toWidth(payload.buildContext) ??
                double.infinity,
            minHeight:
                props.string('minHeight')?.toHeight(payload.buildContext) ?? 0,
            minWidth:
                props.string('minWidth')?.toWidth(payload.buildContext) ?? 0),
        child: child?.render(payload));

    if (elevation > 0) {
      container = Material(
        elevation: elevation,
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: container,
      );
    }

    return container;
  }
}

DecorationImage? _toDecorationImage(
    RenderPayload payload, Map<String, dynamic> props) {
  ImageProvider? imageProvider = props.string('source').let((source) {
    if (source.contains('http')) {
      return CachedNetworkImageProvider(source);
    }

    return AssetImage(source);
  });

  if (imageProvider == null) return null;

  final imageAlignment = DUIDecoder.toAlignment(props['alignment']);
  final imageOpacity = payload.eval<double>(props['opacity']);

  return DecorationImage(
      opacity: imageOpacity ?? 1.0,
      image: imageProvider,
      alignment: imageAlignment ?? Alignment.center,
      fit: DUIDecoder.toBoxFit(props['fit']));
}

BorderWithPattern? _toBorderWithPattern(
    RenderPayload payload, Map<String, dynamic>? props) {
  if (props == null) return null;

  final strokeWidth =
      NumDecoder.toDoubleOrDefault(props['borderWidth'], defaultValue: 0);

  if (strokeWidth <= 0) return null;

  final borderColor = makeColor(payload.eval<String>(props['borderColor'])) ??
      Colors.transparent;
  final dashPattern = DUIDecoder.toDashPattern(
          props.valueFor(keyPath: 'borderType.dashPattern')) ??
      const [3, 1];
  final strokeCap =
      DUIDecoder.toStrokeCap(props.valueFor(keyPath: 'borderType.strokeCap')) ??
          StrokeCap.butt;
  final borderGradiant =
      toGradiant(props['borderGradiant'], payload.buildContext);

  final BorderPattern borderPattern = DUIDecoder.toBorderPattern(
          props.valueFor(keyPath: 'borderType.borderPattern')) ??
      BorderPattern.solid;
  final strokeAlign =
      DUIDecoder.toStrokeAlign(props['strokeAlign']) ?? StrokeAlign.center;

  return BorderWithPattern(
    strokeWidth: strokeWidth,
    color: borderColor,
    dashPattern: dashPattern,
    strokeCap: strokeCap,
    gradient: borderGradiant,
    borderPattern: borderPattern,
    strokeAlign: strokeAlign,
  );
}
