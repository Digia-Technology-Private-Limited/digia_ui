import 'package:flutter/material.dart';

import '../Utils/extensions.dart';
import '../core/page/dui_page_bloc.dart';
import 'dui_widget_scope.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class DUIWidgetState<T extends BaseStatefulWidget> extends State<T> {
  Map<String, Function> getVariables();
  String? get name;

  @override
  void initState() {
    if (name != null) {
      context.tryRead<DUIPageBloc>()?.register(name!, getVariables());
    }
    super.initState();
  }
}

// class DUIStatefulBuilder extends StatefulWidget {
//   /// Creates a widget that both has state and delegates its build to a callback.
//   const DUIStatefulBuilder(
//       {super.key, required this.builder, required this.onInit});

//   final Widget Function(BuildContext context, StateSetter) builder;
//   final VoidCallback onInit;

//   @override
//   State<DUIStatefulBuilder> createState() => _StatefulBuilderState();
// }

// class _StatefulBuilderState extends State<DUIStatefulBuilder> {
//   @override
//   void initState() {
//     widget.onInit();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) => widget.builder(context, setState);
// }
