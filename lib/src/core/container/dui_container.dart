import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../components/utils/DUIStyleClass/dui_style_class.dart';

class DUIContainer extends StatelessWidget {
  final DUIStyleClass? styleClass;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final Widget? child;

  const DUIContainer(
      {super.key,
      required this.styleClass,
      this.alignment,
      this.padding,
      this.color,
      this.decoration,
      this.foregroundDecoration,
      this.width,
      this.height,
      this.constraints,
      this.margin,
      this.transform,
      this.transformAlignment,
      this.clipBehavior = Clip.none,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        DUIDecoder.toBorderRadius(styleClass?.border?.borderRadius?.toJson());

    return Container(
        alignment: alignment ?? DUIDecoder.toAlignment(styleClass?.alignment),
        padding:
            padding ?? DUIDecoder.toEdgeInsets(styleClass?.padding?.toJson()),
        decoration: BoxDecoration(
            border: toBorder(styleClass?.border),
            color: color ?? styleClass?.bgColor.letIfTrue(toColor),
            borderRadius: borderRadius),
        foregroundDecoration: foregroundDecoration,
        width: width ?? double.tryParse(styleClass?.width ?? ''),
        height: height ?? _height(context, styleClass?.height),
        constraints: constraints,
        margin: margin ?? DUIDecoder.toEdgeInsets(styleClass?.margin?.toJson()),
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: borderRadius.isZero() ? clipBehavior : Clip.hardEdge,
        child: child);
  }

  double? _height(BuildContext context, String? heightStringValue) {
    if (heightStringValue == null || heightStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(heightStringValue);
    if (parsedValue != null) return parsedValue;

    if (heightStringValue.characters.last == '%') {
      final substring =
          heightStringValue.substring(0, heightStringValue.length - 1);
      final heightFactor = double.tryParse(substring);
      if (heightFactor == null) return null;

      return MediaQuery.of(context).size.height * (heightFactor / 100);
    }

    return null;
  }
}
