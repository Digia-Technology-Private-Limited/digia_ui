import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_base_stateful_widget.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../action/api_handler.dart';
import '../evaluator.dart';
import '../indexed_item_provider.dart';
import '../json_widget_builder.dart';
import '../page/dui_page_bloc.dart';
import 'dui_json_widget_builder.dart';

class DUIPaginatedListViewBuilder extends DUIWidgetBuilder {
  DUIPaginatedListViewBuilder({required super.data, this.registry});
  final DUIWidgetRegistry? registry;

  static DUIPaginatedListViewBuilder? create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIPaginatedListViewBuilder(data: data, registry: registry);
  }

  @override
  Widget build(BuildContext context) {
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
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 1);
  late int pageSize;
  late Map<String, dynamic> dataSource;

  @override
  void initState() {
    super.initState();
    pageSize = widget.data.props['pageSize'];
    dataSource = widget.data.props['dataSource'];
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, pageSize, context);
    });
  }

  _fetchPage(int pageKey, int pageSize, BuildContext context) async {
    final List<Map<String, dynamic>> newItems = await _makeFuture(
            dataSource: dataSource,
            pageKey: pageKey,
            pageSize: pageSize,
            context: context) ??
        [];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.data.children['children']!;

    List items = _createDataItems(widget.data.dataRef, context);
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
      if (children.isEmpty) return const SizedBox.shrink();

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
            return IndexedItemWidgetBuilder(
                index: index,
                currentItem: items[index],
                builder: DUIJsonWidgetBuilder(
                    data: childToRepeat, registry: widget.registry!));
          },
          firstPageProgressIndicatorBuilder: (context) =>
              const Center(child: Text('first page indicator')),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: Text('new page indicator')),
          firstPageErrorIndicatorBuilder: (context) =>
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

  List<Object> _createDataItems(
      Map<String, dynamic> dataRef, BuildContext context) {
    if (dataRef.isEmpty) return [];
    if (widget.data.dataRef['kind'] == 'json') {
      return (widget.data.dataRef['datum'] as List<dynamic>?)?.cast<Object>() ??
          [];
    } else {
      return eval<List>(
            widget.data.dataRef['datum'],
            context: context,
            decoder: (p0) => p0 as List?,
          )?.cast<Object>() ??
          [];
    }
  }

  Future<List<Map<String, dynamic>>>? _makeFuture(
      {required Map<String, dynamic> dataSource,
      int? pageKey,
      int? pageSize,
      required BuildContext context}) async {
    final apiDataSourceId = dataSource['id'];
    Map<String, dynamic>? apiDataSourceArgs = dataSource['args'];

    final apiModel = (context.tryRead<DUIPageBloc>()?.config ??
            DigiaUIClient.getConfigResolver())
        .getApiDataSource(apiDataSourceId);

    final args = apiDataSourceArgs?.map((key, value) {
      final evalue = eval(value, context: context);
      final dvalue = apiModel.variables?[key]?.defaultValue;
      return MapEntry(key, evalue ?? dvalue);
    });

    return ApiHandler.instance
        .execute(apiModel: apiModel, args: args)
        .then((value) => value.data as List<Map<String, dynamic>>);
  }

  @override
  Map<String, Function> getVariables() {
    return {'': () => print('this is get variables function')};
  }
}
