import 'package:flutter/material.dart';

import '../Utils/extensions.dart';
import '../core/page/dui_page_bloc.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  final String? varName;
  const BaseStatefulWidget({required this.varName, super.key});
}

abstract class DUIWidgetState<T extends BaseStatefulWidget> extends State<T> {
  Map<String, Function> getVariables();

  @override
  void initState() {
    if (widget.varName != null) {
      context.tryRead<DUIPageBloc>()?.register(widget.varName!, getVariables());
    }
    super.initState();
  }
}
