import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/core/action/action_handler.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';

import '../image/image.dart';
import 'tech_card.props.dart';

class DUITechCard extends StatefulWidget {
  final DUITechCardProps props;

  const DUITechCard(this.props, {super.key}) : super();

  factory DUITechCard.create(Map<String, dynamic> json) =>
      DUITechCard(DUITechCardProps.fromJson(json));

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
    final widget = DUIContainer(
        styleClass: props.styleClass,
        width: props.width,
        height: props.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DUIImage(props.image),
            const Spacer(),
            SizedBox(height: NumDecoder.toDouble(props.spaceBtwImageAndTitle)),
            DUIText(props.title),
            DUIText(props.subText),
          ],
        ));

    return props.onClick == null
        ? widget
        : InkWell(
            onTap: () {
              ActionHandler().executeAction(context, props.onClick!);
            },
            child: widget,
          );
  }
}
