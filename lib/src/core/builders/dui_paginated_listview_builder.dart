import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_base_stateful_widget.dart';
import '../action/action_handler.dart';
import '../action/api_handler.dart';
import '../bracket_scope_provider.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'common.dart';
import 'dui_json_widget_builder.dart';

class DUIPaginatedListViewBuilder extends DUIWidgetBuilder {
  DUIPaginatedListViewBuilder(
      {required super.data, super.registry = DUIWidgetRegistry.shared});

  static DUIPaginatedListViewBuilder? create(DUIWidgetJsonData data) {
    return DUIPaginatedListViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final children = data.children['children']!;

    if (children.isEmpty) return const SizedBox.shrink();

    return DUIPaginatedListView(
      varName: data.varName,
      data: data,
      registry: registry,
    );
  }
}

class DUIPaginatedListView extends BaseStatefulWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;

  const DUIPaginatedListView(
      {required super.varName, required this.data, this.registry, super.key});

  @override
  State<StatefulWidget> createState() => _DUIPaginatedListViewState();
}

class _DUIPaginatedListViewState extends DUIWidgetState<DUIPaginatedListView> {
  final ScrollController _scrollController = ScrollController();
  final PagingController<int, Object> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      final apiDataSourceId =
          widget.data.props.valueFor(keyPath: 'dataSource.id');
      Map<String, dynamic>? apiDataSourceArgs =
          widget.data.props.valueFor(keyPath: 'dataSource.args');

      final apiModel = (context.tryRead<DUIPageBloc>()?.config ??
              DigiaUIClient.getConfigResolver())
          .getApiDataSource(apiDataSourceId);

      final args = apiDataSourceArgs?.map((key, value) {
        final evalue = eval(value,
            context: context,
            enclosing: ExprContext(variables: {'offset': pageKey}));
        final dvalue = apiModel.variables?[key]?.defaultValue;
        return MapEntry(key, evalue ?? dvalue);
      });

      ApiHandler.instance.execute(apiModel: apiModel, args: args).then((resp) {
        final response = {
          'body': resp.data,
          'statusCode': resp.statusCode,
          'headers': resp.headers,
          'requestObj': requestObjToMap(resp.requestOptions),
          'error': null,
        };

        final newItems =
            ifNotNull(widget.data.props['newItemsTransformation'], (p0) {
                  return eval<List>(p0,
                      context: context,
                      enclosing:
                          ExprContext(variables: {'response': response}));
                }) ??
                response['body'];

        if (newItems == null || newItems is! List || newItems.isEmpty) {
          _pagingController.appendLastPage([]);
        } else {
          _pagingController.appendPage(newItems.cast<Object>(), pageKey + 1);
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    final items =
        createDataItemsForDynamicChildren(data: widget.data, context: context);
    _pagingController.value = PagingState(nextPageKey: 2, itemList: items);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.data.children['children']!;

    final generateChildrenDynamically =
        widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;

    final initialScrollPosition = eval<String>(
        widget.data.props['initialScrollPosition'],
        context: context);
    final bool isReverse =
        eval<bool>(widget.data.props['reverse'], context: context) ?? false;

    if (initialScrollPosition == 'end') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }

    if (generateChildrenDynamically) {
      return PagedListView(
        reverse: isReverse,
        pagingController: _pagingController,
        scrollDirection: DUIDecoder.toAxis(widget.data.props['scrollDirection'],
            defaultValue: Axis.vertical),
        physics: DUIDecoder.toScrollPhysics(widget.data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(widget.data.props['shrinkWrap'],
            defaultValue: false),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            final childToRepeat = children.first;
            return BracketScope(
                variables: [('index', index), ('currentItem', item)],
                builder: DUIJsonWidgetBuilder(
                    data: childToRepeat, registry: widget.registry!));
          },
          firstPageProgressIndicatorBuilder: (context) =>
              widget.data
                  .getChild('firstPageLoadingWidget')
                  ?.let((p0) => DUIWidget(data: p0)) ??
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              widget.data
                  .getChild('newPageLoadingWidget')
                  ?.let((p0) => DUIWidget(data: p0)) ??
              const Center(child: CircularProgressIndicator()),
          firstPageErrorIndicatorBuilder: (context) =>
              widget.data
                  .getChild('pageErrorWidget')
                  ?.let((p0) => DUIWidget(data: p0)) ??
              const Center(child: Text('first page error')),
        ),
      );
    } else {
      return ListView.builder(
        reverse: isReverse,
        controller: _scrollController,
        scrollDirection: DUIDecoder.toAxis(widget.data.props['scrollDirection'],
            defaultValue: Axis.vertical),
        physics: DUIDecoder.toScrollPhysics(widget.data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(widget.data.props['shrinkWrap'],
            defaultValue: false),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return DUIJsonWidgetBuilder(
                  data: children[index], registry: widget.registry!)
              .build(context);
        },
      );
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Map<String, Function> getVariables() {
    return {'': () => {}};
  }
}
