import 'package:cached_network_image/cached_network_image.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

import 'package:flutter/material.dart';
import 'dui_container2_props.dart';

class DUIContainer2 extends StatelessWidget {
  final DUIContainer2Props props;
  final DUIWidgetJsonData? child;

  const DUIContainer2(this.props, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    late BoxShape? shape;
    ImageProvider? imageProvider = props.decorationImage?.source.let((source) {
      if (source.contains('http')) {
        return CachedNetworkImageProvider(source);
      }

      return AssetImage(source);
    });
    if (props.shape == 'circle') {
      shape = BoxShape.circle;
    } else {
      shape = BoxShape.rectangle;
    }

    final width = props.width?.toWidth(context);
    final height = props.height?.toHeight(context);
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
          border: (props.border?.borderWidth).let((p0) => Border.all(
                color: borderColor ?? Colors.black,
                width: NumDecoder.toDoubleOrDefault(p0, defaultValue: 1),
              )),
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
  }
}
