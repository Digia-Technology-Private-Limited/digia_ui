import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/components/container/dui_container_props.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:flutter/material.dart';

class DUIContainer extends StatefulWidget {
  final DUIContainerProps props;
  const DUIContainer(this.props, {super.key}) : super();

  @override
  State<DUIContainer> createState() => _DUIContainerState();
}

class _DUIContainerState extends State<DUIContainer> {
  late DUIContainerProps props;
  late double? width;
  late double? height;
  late Alignment? alignment;
  late DUIInsets margin;
  late DUIInsets padding;
  late double? borderRadius;
  late double? borderWidth;
  late Color? color;
  late Color? borderColor;

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = NumDecoder.toDouble(props.width);
    final height = NumDecoder.toDouble(props.height);
    final borderWidth = NumDecoder.toDouble(props.borderWidth);
    final borderRadius = DUIDecoder.toBorderRadius(props.borderRadius);
    final alignment = DUIDecoder.toAlignment(props.alignment);
    final margin = DUIDecoder.toEdgeInsets(props.margin.toJson());
    final padding = DUIDecoder.toEdgeInsets(props.padding.toJson());
    final color = ColorDecoder.fromHexString(props.color ?? '#FFFFFF');
    final borderColor =
        ColorDecoder.fromHexString(props.borderColor ?? '#ABABAB');

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: props.hasBorder ?? false
            ? Border.all(color: borderColor, width: borderWidth ?? 1)
            : null,
        borderRadius: borderRadius,
      ),
    );
  }
}
