import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../dui_base_stateful_widget.dart';

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
  ValueNotifier<dynamic>? _valueNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _valueNotifier =
        eval(widget.data.props['opacity'], context: context) as ValueNotifier?;
    _valueNotifier?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _valueNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_valueNotifier == null) {
      return Text(
        'No Listenable found!!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.red.shade500,
        ),
      );
    }

    return AnimatedBuilder(
        animation: _valueNotifier!,
        builder: (context, _) {
          return BracketScope(
              variables: [('value', _valueNotifier?.value)],
              builder: DUIJsonWidgetBuilder(
                  data: widget.data.getChild('child')!,
                  registry: DUIWidgetRegistry.shared));
        });
  }
}
