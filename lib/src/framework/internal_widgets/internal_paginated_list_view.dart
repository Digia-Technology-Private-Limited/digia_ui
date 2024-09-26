import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InternalPaginatedListView extends StatefulWidget {
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;
  final void Function(int pageKey, PagingController<int, Object> controller)?
      apiRequestHandler;
  final Widget? firstPageLoadingWidget;
  final Widget? newpageLoadingWidget;
  final Widget? pageErrorWidget;
  final String? newItemsTransformation;
  final String initialScrollPosition;
  final bool? isReverse;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const InternalPaginatedListView(
      {super.key,
      this.itemBuilder,
      this.children = const [],
      this.apiRequestHandler,
      this.firstPageLoadingWidget,
      this.newpageLoadingWidget,
      this.pageErrorWidget,
      this.newItemsTransformation,
      this.initialScrollPosition = 'start',
      this.isReverse,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false});

  @override
  State<StatefulWidget> createState() => _InternalPaginatedListViewState();
}

class _InternalPaginatedListViewState extends State<InternalPaginatedListView> {
  final ScrollController _scrollController = ScrollController();
  final PagingController<int, Object> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      if (widget.apiRequestHandler == null) return;
      widget.apiRequestHandler!(pageKey, _pagingController);
    });
  }

  // @override
  // void didChangeDependencies() {
  //   final items =
  //       createDataItemsForDynamicChildren(data: widget.data, context: context);
  //   _pagingController.value = PagingState(nextPageKey: 2, itemList: items);

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final initialScrollPosition = widget.initialScrollPosition;
    final bool isReverse = widget.isReverse ?? false;

    if (initialScrollPosition == 'end') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }

    if (widget.itemBuilder != null) {
      return PagedListView(
        reverse: isReverse,
        pagingController: _pagingController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            return widget.itemBuilder!.call(context, index);
          },
          firstPageProgressIndicatorBuilder: (context) =>
              widget.firstPageLoadingWidget ??
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              widget.newpageLoadingWidget ??
              const Center(child: CircularProgressIndicator()),
          firstPageErrorIndicatorBuilder: (context) =>
              widget.pageErrorWidget ??
              const Center(child: Text('first page error')),
        ),
      );
    } else {
      return ListView.builder(
        reverse: isReverse,
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return widget.children[index];
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
}
