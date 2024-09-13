import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/basic_shared_utils/types.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/evaluator.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../border/box_border_with_pattern/border_with_pattern.dart';
import '../dui_widget.dart';
import '../utils/DUIContainerBorder/dui_container_border.dart';
import 'dui_container2_props.dart';

class DUIContainer2 extends StatelessWidget {
  final DUIContainer2Props props;
  final DUIWidgetJsonData? child;

  const DUIContainer2(this.props, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = props.width?.toWidth(context);
    final height = props.height?.toHeight(context);
    final borderRadius = DUIDecoder.toBorderRadius(props.border?.borderRadius);
    final alignment = DUIDecoder.toAlignment(props.childAlignment);
    final margin = DUIDecoder.toEdgeInsets(props.margin?.toJson());
    final padding = DUIDecoder.toEdgeInsets(props.padding?.toJson());
    final color = makeColor(eval<String>(props.color, context: context));

    BoxShape shape =
        props.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle;
    final gradiant = toGradiant(props.gradiant, context);
    final elevation = props.elevation ?? 0.0;

    Widget container = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          gradient: gradiant,
          color: color,
          border: _toBorderWithPattern(context, props.border),
          borderRadius: props.shape == 'circle' ? null : borderRadius,
          image: _toDecorationImage(context, props),
          shape: shape),
      constraints: BoxConstraints(
          maxHeight: props.maxHeight?.toHeight(context) ?? double.infinity,
          maxWidth: props.maxWidth?.toWidth(context) ?? double.infinity,
          minHeight: props.minHeight?.toHeight(context) ?? 0,
          minWidth: props.minWidth?.toWidth(context) ?? 0),
      child: child.let((p0) => DUIWidget(data: p0)),
    );

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
    BuildContext context, DUIContainer2Props props) {
  ImageProvider? imageProvider = props.decorationImage?.source.let((source) {
    if (source.contains('http')) {
      return CachedNetworkImageProvider(source);
    }

    return AssetImage(source);
  });

  if (imageProvider == null) return null;

  final imageAlignment =
      DUIDecoder.toAlignment(props.decorationImage?.alignment);
  final imageOpacity =
      eval<double>(props.decorationImage?.opacity, context: context);
  return DecorationImage(
      opacity: imageOpacity ?? 1.0,
      image: imageProvider,
      alignment: imageAlignment ?? Alignment.center,
      fit: DUIDecoder.toBoxFit(props.decorationImage?.fit));
}

BorderWithPattern? _toBorderWithPattern(
    BuildContext context, DUIContainerBorder? border) {
  if (border == null) return null;

  final strokeWidth =
      NumDecoder.toDoubleOrDefault(border.borderWidth, defaultValue: 0);

  if (strokeWidth <= 0) return null;

  final borderColor =
      makeColor(eval<String>(border.borderColor, context: context)) ??
          Colors.transparent;
  final dashPattern =
      DUIDecoder.toDashPattern(border.borderType?.dashPattern) ?? const [3, 1];
  final strokeCap = border.borderType?.strokeCap ?? StrokeCap.butt;
  final borderGradiant = toGradiant(border.borderGradiant, context);

  final borderPattern = border.borderType?.borderPattern ?? BorderPattern.solid;
  final strokeAlign = border.strokeAlign ?? StrokeAlign.center;

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
