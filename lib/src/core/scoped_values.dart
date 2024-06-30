import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../digia_ui.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import 'app_state_provider.dart';
import 'async_data_provider.dart';
import 'indexed_item_provider.dart';
import 'page/dui_page_bloc.dart';

ExprContext createScope(BuildContext context, ExprContext? localScope) {
  // Global Level
  ExprContext globalScope = ExprContext(name: 'global', variables: {
    ...?AppStateProvider.maybeOf(context)?.variables,
    ...DigiaUIClient.instance.jsVars
  });

  // Prepare Page Level Vars
  final pageState = context.read<DUIPageBloc>().state;
  final widgetVariables = pageState.widgetVars.map((k, v) => MapEntry(
      k,
      ExprClassInstance(
          klass: ExprClass(
              name: k,
              fields: v.map((k1, v1) => MapEntry(k1, v1())),
              methods: {}))));
  ExprContext pageScope = ExprContext(
      name: 'page/${pageState.pageUid}',
      variables: {
        ...?pageState.props.variables?.map((k, v) => MapEntry(k, v.value)),
        ...widgetVariables,
        'pageParams': pageState.props.inputArgs?.map((key, value) =>
            MapEntry(key, pageState.pageArgs?[key] ?? value.value)),
        'dataSource': pageState.dataSource
      },
      enclosing: globalScope);

  // Index scope for ListViews/GridViews
  final indexScope = ifNotNull(IndexedItemWidgetBuilder.maybeOf(context), (p0) {
        return ExprContext(
            name: 'indexed',
            variables: {'index': p0.index, 'currentItem': p0.currentItem},
            enclosing: pageScope);
      }) ??
      pageScope;

  // Async scope for StreamBuilders/FutureBuilders
  // final asyncScope = ifNotNull(AsyncDataProvider.maybeOf(context), (p0) {
  //       return ExprContext(
  //           name: 'async',
  //           variables: {p0.key.toString(): p0.data},
  //           enclosing: pageScope);
  //     }) ??
  //     pageScope;

  // Wrap the scope chain from above over localSCope
  return ifNotNull(
          localScope,
          ((p0) => p0
            ..appendEnclosing(
              indexScope,
            ))) ??
      indexScope;

  // Wrap the scope chain from above over asyncScope
  // return ifNotNull(
  //         localScope,
  //         ((p0) => p0
  //           ..appendEnclosing(
  //             asyncScope,
  //           ))) ??
  //     asyncScope;
}
