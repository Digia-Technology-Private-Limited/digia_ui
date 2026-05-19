import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'paginated_list_controller.dart';

class InternalPaginatedSliverList extends StatefulWidget {
  final Widget Function(BuildContext context, int index, List<Object>? data)
      itemBuilder;

  final void Function(
          dynamic pageKey, PagingController<Object, Object> controller)
      pageRequestListener;
  final PaginatedListController? controller;
  final WidgetBuilder? firstPageLoadingBuilder;
  final WidgetBuilder? newPageLoadingBuilder;
  final WidgetBuilder? pageErrorBuilder;
  final List<Object> items;
  final Object firstPageKey;

  const InternalPaginatedSliverList({
    super.key,
    required this.itemBuilder,
    required this.items,
    required this.pageRequestListener,
    required this.firstPageKey,
    this.controller,
    this.firstPageLoadingBuilder,
    this.newPageLoadingBuilder,
    this.pageErrorBuilder,
  });

  @override
  State<StatefulWidget> createState() => _InternalPaginatedSliverListState();
}

class _InternalPaginatedSliverListState
    extends State<InternalPaginatedSliverList> {
  late final PagingController<Object, Object> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: widget.firstPageKey);
    _pagingController.addPageRequestListener(
      (pageKey) => widget.pageRequestListener(pageKey, _pagingController),
    );
    widget.controller?.addListener(_onRefreshRequested);
  }

  @override
  void didUpdateWidget(covariant InternalPaginatedSliverList oldWidget) {
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
    return PagedSliverList<Object, Object>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (cntx, item, index) =>
            widget.itemBuilder(context, index, _pagingController.itemList),
        firstPageErrorIndicatorBuilder: widget.pageErrorBuilder ??
            (context) {
              return const Center(child: Text('first page error'));
            },
        newPageErrorIndicatorBuilder: (context) => const SizedBox.shrink(),
        firstPageProgressIndicatorBuilder: widget.firstPageLoadingBuilder,
        newPageProgressIndicatorBuilder: widget.newPageLoadingBuilder,
        noItemsFoundIndicatorBuilder: (context) => const SizedBox.shrink(),
        noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onRefreshRequested);
    _pagingController.dispose();
    super.dispose();
  }
}
