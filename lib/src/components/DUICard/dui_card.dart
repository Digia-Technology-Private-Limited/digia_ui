import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/components/DUICard/dui_card_props.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/image/image.dart';
import 'package:digia_ui/src/core/container/dui_container.dart';
import 'package:flutter/material.dart';

class DUICard extends StatefulWidget {
  final DUICardProps props;

  const DUICard(this.props, {super.key}) : super();

  factory DUICard.create(Map<String, dynamic> json) =>
      DUICard(DUICardProps.fromJson(json));

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
    return InkWell(
      onTap: () {},
      child: DUIContainer(
          styleClass: props.styleClass,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: DUIImage(props.image),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      DUIDecoder.toEdgeInsets(props.contentPadding.toJson()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DUIText(props.topCrumbText),
                      SizedBox(
                          height: NumDecoder.toDouble(
                              props.spaceBtwTopCrumbTextTitle)),
                      DUIText(props.title),
                      const Spacer(),
                      Row(
                        children: [
                          DUIImage(props.avatarImage),
                          SizedBox(
                            width: NumDecoder.toDouble(
                                props.spaceBtwAvatarImageAndText),
                          ),
                          DUIText(props.avatarText)
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
