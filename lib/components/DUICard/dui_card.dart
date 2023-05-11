import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUICard/dui_card_props.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:flutter/material.dart';

class DUICard extends StatefulWidget {
  final DUICardProps props;

  const DUICard(this.props, {super.key}) : super();

  @override
  State<DUICard> createState() => _DUICardState();
}

class _DUICardState extends State<DUICard> {
  late DUICardProps props;

  _DUICardState();

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: props.height,
        width: props.width,
        margin: getInsets(
          left: props.insets.left,
          right: props.insets.right,
          top: props.insets.top,
          bottom: props.insets.bottom,
        ),
        decoration: BoxDecoration(
          color: getColor(props.color),
          borderRadius: props.cornerRadius.getCornerRadius(),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: DUIImage(props.thumbnail),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: getInsets(
                  left: props.insets.left,
                  right: props.insets.right,
                  top: props.insets.top,
                  bottom: props.insets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DUIText(props.date),
                    DUIText(props.title),
                    Row(
                      children: [
                        DUIImage(props.authorProfile),
                        SizedBox(
                          width: ConfigResolver().getSpacing("sp-200"),
                        ),
                        DUIText(props.authorName)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
