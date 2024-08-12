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

    final width = props.width?.toWidth(context);
    final height = props.height?.toHeight(context);
    final borderRadius = DUIDecoder.toBorderRadius(props.border?.borderRadius);
    final alignment = DUIDecoder.toAlignment(props.childAlignment);
    final margin = DUIDecoder.toEdgeInsets(props.margin?.toJson());
    final padding = DUIDecoder.toEdgeInsets(props.padding?.toJson());
    final color = makeColor(eval<String>(props.color, context: context));
    final borderColor =
        makeColor(eval<String>(props.border?.borderColor, context: context));
    final imageAlignment =
        DUIDecoder.toAlignment(props.decorationImage?.alignment);
    final imageOpacity =
        eval<double>(props.decorationImage?.opacity, context: context);
    BoxShape shape =
        props.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle;
    final gradiant = toGradiant(props.gradiant, context);
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          gradient: gradiant,
          color: gradiant == null ? color : null,
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
