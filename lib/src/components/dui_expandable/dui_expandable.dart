import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class DUIExpandable extends StatefulWidget {

  const DUIExpandable({super.key});

  @override
  State<DUIExpandable> createState() => _DUIExpandableState();
}

class _DUIExpandableState extends State<DUIExpandable> {
  @override
  Widget build(BuildContext context) {
    return Expandable(
      collapsed: Container(),
      expanded: Container(),
      theme: const ExpandableThemeData(
        bodyAlignment: ExpandablePanelBodyAlignment.left,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconPlacement: ExpandablePanelIconPlacement.left,

      ),
      controller: ExpandableController(initialExpanded: true),key: UniqueKey(),
    );
  }
}
