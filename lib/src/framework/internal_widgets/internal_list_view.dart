import 'package:flutter/widgets.dart';

class InternalListView extends StatefulWidget {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String? initialScrollPosition;
  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;

  const InternalListView(
      {super.key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.physics,
      this.shrinkWrap = false,
      this.initialScrollPosition,
      this.itemCount = -1,
      this.itemBuilder,
      this.children = const []});

  @override
  State<InternalListView> createState() => _InternalListViewState();
}

class _InternalListViewState extends State<InternalListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController(
      keepScrollOffset: true,
    );
    super.initState();

    if (widget.initialScrollPosition == 'end') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemBuilder != null) {
      return ListView.builder(
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: widget.itemCount,
        itemBuilder: (ctx, i) => widget.itemBuilder?.call(ctx, i),
      );
    }

    return ListView(
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      children: widget.children,
    );
  }
}
