import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'paginated_list_controller.dart';
import 'scrollable_position_mixin.dart';

class PaginatedListView extends StatefulWidget {
  final Widget Function(BuildContext context, int index, List<Object>? data)
      itemBuilder;
  final void Function(
          dynamic pageKey, PagingController<Object, Object> controller)
      pageRequestListener;

  final List<Object> items;
  final PaginatedListController? controller;
  final String? initialScrollPosition;
  final bool? isReverse;
  final Object firstPageKey;
  final WidgetBuilder? firstPageLoadingBuilder;
  final WidgetBuilder? newPageLoadingBuilder;
  final WidgetBuilder? pageErrorBuilder;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.pageRequestListener,
    required this.firstPageKey,
    this.controller,
    this.firstPageLoadingBuilder,
    this.newPageLoadingBuilder,
    this.pageErrorBuilder,
    this.initialScrollPosition,
    this.isReverse,
  });

  @override
  State<StatefulWidget> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView>
    with ScrollablePositionMixin {
  late final ScrollController _scrollController;
  late final PagingController<Object, Object> _pagingController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pagingController = PagingController(firstPageKey: widget.firstPageKey);
    _pagingController.addPageRequestListener(
      (pageKey) => widget.pageRequestListener(pageKey, _pagingController),
    );
    widget.controller?.addListener(_onRefreshRequested);
    setInitialScrollPosition(_scrollController, widget.initialScrollPosition);
  }

  @override
  void didUpdateWidget(covariant PaginatedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onRefreshRequested);
      widget.controller?.addListener(_onRefreshRequested);
    }
  }

  void _onRefreshRequested() {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final bool isReverse = widget.isReverse ?? false;

    return PagedListView<Object, Object>(
      reverse: isReverse,
      scrollController: _scrollController,
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) =>
            widget.itemBuilder(context, index, _pagingController.itemList),
        firstPageProgressIndicatorBuilder: widget.firstPageLoadingBuilder,
        newPageProgressIndicatorBuilder: widget.newPageLoadingBuilder,
        firstPageErrorIndicatorBuilder: widget.pageErrorBuilder ??
            (context) {
              return const Center(child: Text('first page error'));
            },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onRefreshRequested);
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}
