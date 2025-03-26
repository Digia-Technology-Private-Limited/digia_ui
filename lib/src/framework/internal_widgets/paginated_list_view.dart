import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'scrollable_position_mixin.dart';

class PaginatedListView extends StatefulWidget {
  final Widget Function(BuildContext context, int index, List<Object>? data)
      itemBuilder;
  final void Function(
          dynamic pageKey, PagingController<Object, Object> controller)
      pageRequestListener;

  final List<Object> items;
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
  late ScrollController _scrollController;
  late PagingController<Object, Object> _pagingController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _pagingController = PagingController(
      firstPageKey: widget.firstPageKey,
    );

    super.initState();

    setInitialScrollPosition(_scrollController, widget.initialScrollPosition);

    _pagingController.addPageRequestListener(
      (pageKey) => widget.pageRequestListener(
        pageKey,
        _pagingController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isReverse = widget.isReverse ?? false;

    return PagedListView(
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
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}
