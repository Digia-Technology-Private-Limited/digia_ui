import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../components/border/box_border_with_pattern/border_with_pattern.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/custom_flutter_types.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';

class VWContainer extends VirtualStatelessWidget<Props> {
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

    final borderRadius = To.borderRadius(props.get('border.borderRadius'));

    final alignment = To.alignment(props.get('childAlignment'));
    final margin = To.edgeInsets(props.get('margin'));
    final padding = To.edgeInsets(props.get('padding'));
    final color = payload.evalColor(props.get('color'));

    BoxShape shape = props.getString('shape') == 'circle'
        ? BoxShape.circle
        : BoxShape.rectangle;
    final gradiant = To.gradient(props.getMap('gradiant'),
        evalColor: (it) => payload.evalColor(it));
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

  final imageAlignment = To.alignment(props.get('alignment'));
  final imageOpacity = payload.eval<double>(props.get('opacity'));

  return DecorationImage(
      opacity: imageOpacity ?? 1.0,
      image: imageProvider,
      alignment: imageAlignment ?? Alignment.center,
      fit: To.boxFit(props.get('fit')));
}

BorderWithPattern? _toBorderWithPattern(RenderPayload payload, Props props) {
  if (props.isEmpty) return null;

  final strokeWidth = props.getDouble('borderWidth') ?? 0;

  if (strokeWidth <= 0) return null;

  final borderColor =
      payload.evalColor(props.get('borderColor')) ?? Colors.transparent;
  final dashPattern =
      To.dashPattern(props.get('borderType.dashPattern')) ?? const [3, 1];
  final strokeCap =
      To.strokeCap(props.get('borderType.strokeCap')) ?? StrokeCap.butt;
  final borderGradiant =
      To.gradient(props.getMap('borderGradiant'), evalColor: payload.evalColor);

  final BorderPattern borderPattern =
      To.borderPattern(props.get('borderType.borderPattern')) ??
          BorderPattern.solid;
  final strokeAlign =
      To.strokeAlign(props.get('strokeAlign')) ?? StrokeAlign.center;

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
