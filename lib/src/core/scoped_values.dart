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
  if (pageState.dataSource != null ||
      pageState.props.variables != null ||
      pageState.pageArgs != null) {
    scope = ExprContext(variables: {
      ...?pageState.props.variables?.map((k, v) => MapEntry(k, v.value)),
      'pageParams': pageState.pageArgs,
      'dataSource': pageState.dataSource
    }, enclosing: scope);
  }

  final indexedItemProvider = IndexedItemWidgetBuilder.maybeOf(context);
  scope = ifNotNull(indexedItemProvider, (p0) {
        return ExprContext(
            variables: {'index': p0.index, 'currentItem': p0.currentItem},
            enclosing: scope);
      }) ??
      scope;

  return scope;
}
