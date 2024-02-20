import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/image/cached_image_wrapper.dart';
import 'package:flutter/material.dart';
import 'dui_container2_props.dart';

class DUIContainer2 extends StatelessWidget {
  final DUIContainer2Props props;

  const DUIContainer2(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    late BoxShape? shape;
    ImageProvider? imageProvider = props.decorationImage?.source.let((source) {
      return DUIImageProvider(source: source).provider;
    });
    if (props.shape == 'circle') {
      shape = BoxShape.circle;
    } else {
      shape = BoxShape.rectangle;
    }

    final width = _toWidth(context, props.width);
    final height = _toHeight(context, props.height);
    final borderWidth = _toWidth(context, props.border?.borderWidthStr);
    final borderRadius = DUIDecoder.toBorderRadius(props.border?.borderRadius);
    final alignment = DUIDecoder.toAlignment(props.childAlignment);
    final margin = DUIDecoder.toEdgeInsets(props.margin?.toJson());
    final padding = DUIDecoder.toEdgeInsets(props.padding?.toJson());
    final color = props.color.letIfTrue(toColor);
    final borderColor = props.border?.borderColor.letIfTrue(toColor);
    final imageAlignment =
        DUIDecoder.toAlignment(props.decorationImage?.alignment);
    final imageOpacity = NumDecoder.toDouble(props.decorationImage?.opacity);

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          border: borderWidth == null
              ? null
              : Border.all(
                  color: borderColor ?? Colors.black,
                  width: borderWidth,
                ),
          borderRadius: props.shape == 'circle'
              ? null
              : BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  topRight: borderRadius.topRight,
                  bottomLeft: borderRadius.bottomLeft,
                  bottomRight: borderRadius.bottomRight,
                ),
          image: imageProvider == null
              ? null
              : DecorationImage(
                  opacity: imageOpacity ?? 1.0,
                  image: imageProvider,
                  alignment: imageAlignment ?? Alignment.center,
                  fit: DUIDecoder.toBoxFit(props.decorationImage?.fit)),
          shape: shape),
      constraints: BoxConstraints(
          maxHeight: _toHeight(context, props.maxHeight) ?? double.infinity,
          maxWidth: _toWidth(context, props.maxWidth) ?? double.infinity,
          minHeight: _toHeight(context, props.minHeight) ?? 0,
          minWidth: _toWidth(context, props.minWidth) ?? 0),
    );
  }

  double? _toHeight(BuildContext context, String? extentStringValue) {
    if (extentStringValue == null || extentStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(extentStringValue);
    if (parsedValue != null) return parsedValue;

    if (extentStringValue.characters.last == '%') {
      final substring =
          extentStringValue.substring(0, extentStringValue.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return MediaQuery.of(context).size.height * (factor / 100);
    }

    return null;
  }

  double? _toWidth(BuildContext context, String? extentStringValue) {
    if (extentStringValue == null || extentStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(extentStringValue);
    if (parsedValue != null) return parsedValue;

    if (extentStringValue.characters.last == '%') {
      final substring =
          extentStringValue.substring(0, extentStringValue.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return MediaQuery.of(context).size.width * (factor / 100);
    }

    return null;
  }
}
