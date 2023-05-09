import 'dart:developer';

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
    return Container(
      margin: props.margin.margins(),
      child: InkWell(
        onTap: () {
          log('Button Clicked');
        },
        child: Container(
          width: props.width,
          padding: props.padding.margins(),
          height: props.height,
          decoration: BoxDecoration(
            color: Color(int.parse('0xFF${props.backgroundColor}')),
            borderRadius: props.cornerRadius.getRadius(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DUIImage(props.image),
              Text(
                props.text1,
                style: TextStyle(
                  fontSize: props.font1Size ?? 14,
                  color: Color(int.parse('0xFF${props.text1Color}')),
                ),
              ),
              Text(
                props.text2,
                style: TextStyle(
                  fontSize: props.font2Size ?? 14,
                  color: Color(int.parse('0xFF${props.text2Color}')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
