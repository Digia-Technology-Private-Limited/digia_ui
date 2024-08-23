import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/evaluator.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../dui_widget.dart';
import 'dui_container2_props.dart';

enum BorderType { only, all }

class DUIContainer2 extends StatelessWidget {
  final DUIContainer2Props props;
  final DUIWidgetJsonData? child;

  const DUIContainer2(this.props, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider = props.decorationImage?.source.let((source) {
      if (source.contains('http')) {
        return CachedNetworkImageProvider(source);
      }

      return AssetImage(source);
    });

    final bordertype = toBorderType(props.border?['borderType']['value']);

    final width = props.width?.toWidth(context);
    final height = props.height?.toHeight(context);
    final borderRadius =
        DUIDecoder.toBorderRadius(props.border?['borderRadius']);
    final alignment = DUIDecoder.toAlignment(props.childAlignment);
    final margin = DUIDecoder.toEdgeInsets(props.margin?.toJson());
    final padding = DUIDecoder.toEdgeInsets(props.padding?.toJson());
    final color = makeColor(eval<String>(props.color, context: context));
    final borderColor = makeColor(
            eval<String>(props.border?['borderColor'], context: context)) ??
        Colors.black;
    final imageAlignment =
        DUIDecoder.toAlignment(props.decorationImage?.alignment);
    final imageOpacity =
        eval<double>(props.decorationImage?.opacity, context: context);
    BoxShape shape =
        props.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle;
    final gradiant = toGradiant(props.gradiant, context);
    final elevation = props.elevation ?? 0.0;
    final onlyBorderWidth =
        toBorderWidth(props.border?['borderType']['onlyBorderWidth']);

    Widget container = Container(
      width: width,
      height: height,
      alignment: alignment,
      // margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          gradient: gradiant,
          color: gradiant == null ? color : null,
          border: (bordertype == BorderType.all)
              ? (NumDecoder.toDoubleOrDefault(
                          props.border?['borderType']['allBorderWidth'],
                          defaultValue: 0) >
                      0)
                  ? Border.all(
                      color: borderColor,
                      width: NumDecoder.toDoubleOrDefault(
                          props.border?['borderType']['allBorderWidth'],
                          defaultValue: 0),
                    )
                  : null
              : Border(
                  top: onlyBorderWidth.top > 0
                      ? BorderSide(
                          color: borderColor,
                          width: onlyBorderWidth.top,
                        )
                      : BorderSide.none,
                  bottom: onlyBorderWidth.bottom > 0
                      ? BorderSide(
                          color: borderColor,
                          width: onlyBorderWidth.bottom,
                        )
                      : BorderSide.none,
                  left: onlyBorderWidth.left > 0
                      ? BorderSide(
                          color: borderColor,
                          width: onlyBorderWidth.left,
                        )
                      : BorderSide.none,
                  right: onlyBorderWidth.right > 0
                      ? BorderSide(
                          color: borderColor,
                          width: onlyBorderWidth.right,
                        )
                      : BorderSide.none,
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

    return Padding(
      padding: margin,
      child: container,
    );
  }

  BorderWidth toBorderWidth(dynamic value) {
    if (value == null) return BorderWidth();
    List<double> data = [];
    if (value is String) {
      data = value
          .split(',')
          .map((e) => NumDecoder.toDoubleOrDefault(e, defaultValue: 0))
          .nonNulls
          .toList();
    }
    switch (data.length) {
      case 1:
        return BorderWidth(left: data[0]);
      case 2:
        return BorderWidth(left: data[0], top: data[1]);
      case 3:
        return BorderWidth(left: data[0], top: data[1], right: data[2]);
      case 4:
        return BorderWidth(
            left: data[0], top: data[1], right: data[2], bottom: data[3]);
      default:
        return BorderWidth();
    }
  }

  BorderType toBorderType(dynamic value) {
    return switch (value) {
      'all' => BorderType.all,
      'only' => BorderType.only,
      _ => BorderType.only
    };
  }
}

class BorderWidth {
  final double _left;
  final double _right;
  final double _top;
  final double _bottom;

  double get left => _left;
  double get right => _right;
  double get top => _top;
  double get bottom => _bottom;

  BorderWidth({
    double? left,
    double? right,
    double? top,
    double? bottom,
  })  : _left = left ?? 0.0,
        _right = right ?? 0.0,
        _top = top ?? 0.0,
        _bottom = bottom ?? 0.0;
}
