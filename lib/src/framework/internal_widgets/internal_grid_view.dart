import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class InternalGridView extends StatefulWidget {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final SliverSimpleGridDelegate gridDelegate;
  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Axis? scrollDirection;

  const InternalGridView({
    super.key,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.itemCount = -1,
    this.itemBuilder,
    this.scrollDirection,
    required this.gridDelegate,
  });

  @override
  State<InternalGridView> createState() => _InternalGridViewState();
}

class _InternalGridViewState extends State<InternalGridView> {
  @override
  Widget build(BuildContext context) {
    return AlignedGridView.custom(
      mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
      crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
      controller: widget.controller,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      padding: EdgeInsets.zero,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      gridDelegate: widget.gridDelegate,
      itemCount: widget.itemCount,
      itemBuilder: (ctx, i) => widget.itemBuilder!.call(ctx, i),
    );
  }
}
