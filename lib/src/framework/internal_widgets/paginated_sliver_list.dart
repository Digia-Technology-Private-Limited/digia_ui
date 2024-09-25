import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InternalPaginatedSliverList extends StatefulWidget {
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;
  final Future<void> Function(
      int pageKey, PagingController<int, Object> controller) apiRequestHandler;
  final String dataSourceId;
  final Map<String, dynamic>? dataSourceArgs;
  final Widget? firstPageLoadingWidget;
  final Widget? newpageLoadingWidget;
  final Widget? pageErrorWidget;
  final String? newItemsTransformation;

  const InternalPaginatedSliverList(
      {this.itemBuilder,
      required this.children,
      required this.apiRequestHandler,
      required this.dataSourceId,
      this.dataSourceArgs,
      this.firstPageLoadingWidget,
      this.newpageLoadingWidget,
      this.pageErrorWidget,
      this.newItemsTransformation});

  @override
  State<StatefulWidget> createState() => _InternalPaginatedSliverListState();
}

class _InternalPaginatedSliverListState
    extends State<InternalPaginatedSliverList> {
  final ScrollController _scrollController = ScrollController();
  final PagingController<int, Object> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      widget.apiRequestHandler(pageKey, _pagingController);
    });
  }

  @override
  void didChangeDependencies() {
    // final items =
    //     createDataItemsForDynamicChildren(data: widget.data, context: context);
    // final items=widget.itemBuilder;
    // _pagingController.value = PagingState(nextPageKey: 2, itemList: items);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemBuilder != null) {
      return PagedSliverList(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (cntx, item, index) {
            return widget.itemBuilder!.call(cntx, index);
          },
          firstPageProgressIndicatorBuilder: (cntx) =>
              widget.firstPageLoadingWidget ??
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (cntx) =>
              widget.newpageLoadingWidget ??
              const Center(child: CircularProgressIndicator()),
          firstPageErrorIndicatorBuilder: (cntx) =>
              widget.pageErrorWidget ??
              const Center(child: Text('first page error')),
        ),
      );
    } else {
      return SliverList.builder(
        itemCount: widget.children.length,
        itemBuilder: (cntx, index) {
          return widget.children[index];
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}
