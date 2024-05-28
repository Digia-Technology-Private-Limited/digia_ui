import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Utils/basic_shared_utils/lodash.dart';
import 'app_state_provider.dart';
import 'indexed_item_provider.dart';
import 'page/dui_page_bloc.dart';

ExprContext? createScope(BuildContext context) {
  ExprContext? scope;
  scope = AppStateProvider.maybeOf(context)?.exprContext;

  final pageState = context.read<DUIPageBloc>().state;
  final Map<String, Object?> pageScopedVars = {
    ...?pageState.props.variables?.map((k, v) => MapEntry(k, v.value)),
    'pageParams': pageState.props.inputArgs?.map(
        (key, value) => MapEntry(key, pageState.pageArgs?[key] ?? value.value)),
    'dataSource': pageState.dataSource
  };
  scope = ExprContext(variables: pageScopedVars, enclosing: scope);

  final indexedItemProvider = IndexedItemWidgetBuilder.maybeOf(context);
  scope = ifNotNull(indexedItemProvider, (p0) {
        return ExprContext(
            variables: {'index': p0.index, 'currentItem': p0.currentItem},
            enclosing: scope);
      }) ??
      scope;

  return scope;
}
