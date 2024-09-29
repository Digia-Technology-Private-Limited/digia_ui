import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InternalPaginatedSliverList extends StatefulWidget {
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;
  final void Function(int pageKey, PagingController<int, Object> controller)?
      apiRequestHandler;
  final Widget? firstPageLoadingWidget;
  final Widget? newpageLoadingWidget;
  final Widget? pageErrorWidget;
  final String? newItemsTransformation;

  const InternalPaginatedSliverList(
      {super.key,
      this.itemBuilder,
      this.children = const [],
      this.apiRequestHandler,
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
      if (widget.apiRequestHandler != null) {
        widget.apiRequestHandler!(pageKey, _pagingController);
      }
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
