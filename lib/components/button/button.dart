import 'dart:developer';

import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;

  const DUIButton(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  _DUIButtonState();
  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

