import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InternalPaginatedSliverList extends StatefulWidget {
  final Widget Function(BuildContext context, int index, List<Object>? data)
      itemBuilder;

  final void Function(
          dynamic pageKey, PagingController<Object, Object> controller)
      pageRequestListener;
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
    this.firstPageLoadingBuilder,
    this.newPageLoadingBuilder,
    this.pageErrorBuilder,
  });

  @override
  State<StatefulWidget> createState() => _InternalPaginatedSliverListState();
}

class _InternalPaginatedSliverListState
    extends State<InternalPaginatedSliverList> {
  late PagingController<Object, Object> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: widget.firstPageKey);
    super.initState();

    _pagingController.addPageRequestListener(
      (pageKey) => widget.pageRequestListener(
        pageKey,
        _pagingController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverList(
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
    _pagingController.dispose();
    super.dispose();
  }
}
