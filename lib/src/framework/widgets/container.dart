import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/types.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../components/border/box_border_with_pattern/border_with_pattern.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';

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
    final width = props.getString('width')?.toWidth(payload.buildContext);

    final height = props.getString('height')?.toHeight(payload.buildContext);

    final borderRadius =
        DUIDecoder.toBorderRadius(props.get('border.borderRadius'));

    final alignment = DUIDecoder.toAlignment(props.get('childAlignment'));
    final margin = DUIDecoder.toEdgeInsets(props.get('margin'));
    final padding = DUIDecoder.toEdgeInsets(props.get('padding'));
    final color = makeColor(payload.eval<String>(props.get('color')));

    BoxShape shape = props.getString('shape') == 'circle'
        ? BoxShape.circle
        : BoxShape.rectangle;
    final gradiant = toGradient(props.getMap('gradiant'), payload.buildContext);
    final elevation = props.getDouble('elevation') ?? 0.0;

    Widget container = Container(
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            gradient: gradiant,
            color: color,
            border: _toBorderWithPattern(
                payload, props.toProps('border') ?? Props.empty()),
            borderRadius: shape == BoxShape.circle ? null : borderRadius,
            image:
                _toDecorationImage(payload, props.toProps('decorationImage')),
            shape: shape),
        constraints: BoxConstraints(
          maxHeight:
              props.getString('maxHeight')?.toHeight(payload.buildContext) ??
                  double.infinity,
          maxWidth:
              props.getString('maxWidth')?.toWidth(payload.buildContext) ??
                  double.infinity,
          minHeight:
              props.getString('minHeight')?.toHeight(payload.buildContext) ?? 0,
          minWidth:
              props.getString('minWidth')?.toWidth(payload.buildContext) ?? 0,
        ),
        child: child?.toWidget(payload));

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

DecorationImage? _toDecorationImage(RenderPayload payload, Props? props) {
  ImageProvider? imageProvider = props!.getString('source').maybe((source) {
    if (source.contains('http')) {
      return CachedNetworkImageProvider(source);
    }

    return AssetImage(source);
  });

  if (imageProvider == null) return null;

  final imageAlignment = DUIDecoder.toAlignment(props.get('alignment'));
  final imageOpacity = payload.eval<double>(props.get('opacity'));

  return DecorationImage(
      opacity: imageOpacity ?? 1.0,
      image: imageProvider,
      alignment: imageAlignment ?? Alignment.center,
      fit: DUIDecoder.toBoxFit(props.get('fit')));
}

BorderWithPattern? _toBorderWithPattern(RenderPayload payload, Props props) {
  if (props.isEmpty) return null;

  final strokeWidth = props.getDouble('borderWidth') ?? 0;

  if (strokeWidth <= 0) return null;

  final borderColor =
      makeColor(payload.eval<String>(props.get('borderColor'))) ??
          Colors.transparent;
  final dashPattern =
      DUIDecoder.toDashPattern(props.get('borderType.dashPattern')) ??
          const [3, 1];
  final strokeCap = DUIDecoder.toStrokeCap(props.get('borderType.strokeCap')) ??
      StrokeCap.butt;
  final borderGradiant =
      toGradient(props.getMap('borderGradiant'), payload.buildContext);

  final BorderPattern borderPattern =
      DUIDecoder.toBorderPattern(props.get('borderType.borderPattern')) ??
          BorderPattern.solid;
  final strokeAlign =
      DUIDecoder.toStrokeAlign(props.get('strokeAlign')) ?? StrokeAlign.center;

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
