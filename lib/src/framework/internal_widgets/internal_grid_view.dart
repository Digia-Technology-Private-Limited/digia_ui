import 'package:flutter/widgets.dart';

class InternalGridView extends StatefulWidget {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final SliverGridDelegate gridDelegate;
  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;

  const InternalGridView({
    super.key,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.itemCount = -1,
    this.itemBuilder,
    this.children = const [],
    required this.gridDelegate,
  });

  @override
  State<InternalGridView> createState() => _InternalGridViewState();
}

class _InternalGridViewState extends State<InternalGridView> {
  @override
  Widget build(BuildContext context) {
    if (widget.itemBuilder != null) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        controller: widget.controller,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemCount: widget.itemCount,
        itemBuilder: (ctx, i) => widget.itemBuilder!.call(ctx, i),
        gridDelegate: widget.gridDelegate,
      );
    }

    return GridView(
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      gridDelegate: widget.gridDelegate,
      children: widget.children,
    );
  }
}
