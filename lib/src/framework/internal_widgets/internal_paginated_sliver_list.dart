import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InternalPaginatedSliverList extends StatefulWidget {
  final Widget Function(BuildContext context, int index, List<Object>? data)
      itemBuilder;

  final void Function(int pageKey, PagingController<int, Object> controller)
      pageRequestListener;
  final WidgetBuilder? firstPageLoadingBuilder;
  final WidgetBuilder? newPageLoadingBuilder;
  final WidgetBuilder? pageErrorBuilder;
  final List<Object> items;

  const InternalPaginatedSliverList({
    super.key,
    required this.itemBuilder,
    required this.items,
    required this.pageRequestListener,
    this.firstPageLoadingBuilder,
    this.newPageLoadingBuilder,
    this.pageErrorBuilder,
  });

  @override
  State<StatefulWidget> createState() => _InternalPaginatedSliverListState();
}

class _InternalPaginatedSliverListState
    extends State<InternalPaginatedSliverList> {
  late PagingController<int, Object> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController.fromValue(
      PagingState(itemList: widget.items, nextPageKey: 2),
      firstPageKey: 1,
    );
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
    _pagingController.dispose();
    super.dispose();
  }
}
