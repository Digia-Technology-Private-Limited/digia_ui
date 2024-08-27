import 'dart:async';

import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../core/evaluator.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../dui_base_stateful_widget.dart';
import '../dui_widget.dart';

class DuiAnimationComponent extends BaseStatefulWidget {
  final DUIWidgetJsonData data;

  const DuiAnimationComponent({
    super.key,
    required super.varName,
    required this.data,
  });

  @override
  DuiAnimationComponentState createState() => DuiAnimationComponentState();
}

class DuiAnimationComponentState extends State<DuiAnimationComponent> {
  late ValueNotifier<dynamic>? _valueNotifier;

  @override
  void initState() {
    super.initState();

    _valueNotifier = eval(
      widget.data.props['dataStream'],
      context: context,
    ) as ValueNotifier?;
  }

  @override
  void dispose() {
    _valueNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? child = widget.data.children['child']?.first.let(
      (p0) => DUIWidget(data: p0),
    );

    return _valueNotifier != null
        ? AnimatedBuilder(
            animation: _valueNotifier!,
            builder: (context, widget) {
              return child ?? Container();
            })
        : Text(
            'No Listnable found!!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.red.shade500,
            ),
          );
  }
}
