import 'package:digia_ui/Utils/color_extension.dart';
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
    return Container(
      height: props.height,
      width: props.width,
      margin: props.insets.getInsets(),
      decoration: BoxDecoration(
        color: props.color.toColor(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: DUIText(props.date),
                    ),
                    DUIText(props.title),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          DUIImage(
                            props.authorProfile,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          DUIText(props.authorName)
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
