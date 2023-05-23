import 'dart:developer';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:flutter/material.dart';

import '../image/image.dart';
import 'tech_card.props.dart';

class DUITechCard extends StatefulWidget {
  final DUITechCardProps props;

  const DUITechCard(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUITechCardState();
}

class _DUITechCardState extends State<DUITechCard> {
  late DUITechCardProps props;
  _DUITechCardState();
  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('Button Clicked');
      },
      child: Container(
        width: props.width,
        height: props.height,
        margin: toEdgeInsetsGeometry(props.margin),
        padding: toEdgeInsetsGeometry(props.padding),
        decoration: BoxDecoration(
          color: toColor(props.bgColor),
          borderRadius: toBorderRadiusGeometry(props.cornerRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DUIImage(props.image),
            const Spacer(),
            SizedBox(height: resolveSpacing(props.spaceBtwImageAndTitle)),
            DUIText(props.title),
            DUIText(props.subText),
          ],
        ),
      ),
    );
  }
}
