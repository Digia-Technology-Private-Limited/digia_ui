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
        decoration: BoxDecoration(
          color: toColor(props.bgColor),
          borderRadius: toBorderRadiusGeometry(props.cornerRadius),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: toEdgeInsetsGeometry(props.imageMargin),
                child: DUIImage(props.image),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: toEdgeInsetsGeometry(props.contentMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DUIText(props.topCrumbText),
                    SizedBox(
                        height:
                            resolveSpacing(props.spaceBtwTopCrumbTextTitle)),
                    DUIText(props.title),
                    const Spacer(),
                    Row(
                      children: [
                        DUIImage(props.avatarImage),
                        SizedBox(
                          width:
                              resolveSpacing(props.spaceBtwAvatarImageAndText),
                        ),
                        DUIText(props.avatarText)
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
