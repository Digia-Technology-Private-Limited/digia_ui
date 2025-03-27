import 'package:flutter/material.dart';

class InternalPageView extends StatefulWidget {
  final PageController? controller;
  final Axis? scrollDirection;
  final ScrollPhysics? physics;
  final int itemCount;
  final bool? reverse;
  final bool? pageSnapping;
  final int? initialPage;
  final double? viewportFraction;
  final double? horizontalOffset;
  final double? verticalOffset;
  final bool? keepPage;
  final ValueChanged<int>? onChanged;
  final List<Widget> children;

  final Widget Function(BuildContext context, int index)? itemBuilder;

  const InternalPageView(
      {super.key,
      this.controller,
      this.reverse,
      this.keepPage,
      this.pageSnapping,
      this.viewportFraction,
      this.verticalOffset,
      this.horizontalOffset,
      this.initialPage,
      this.scrollDirection,
      this.physics,
      this.itemCount = -1,
      this.itemBuilder,
      this.children = const [],
      this.onChanged});

  @override
  State<InternalPageView> createState() => _InternalPageViewState();
}

class _InternalPageViewState extends State<InternalPageView> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = widget.controller ??
        PageController(
          initialPage: widget.initialPage ?? 0,
          viewportFraction: widget.viewportFraction ?? 1,
          keepPage: widget.keepPage ?? true,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemBuilder != null) {
      return PageView.builder(
        pageSnapping: widget.pageSnapping ?? true,
        reverse: widget.reverse ?? false,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection ?? Axis.horizontal,
        controller: _pageController,
        itemCount: widget.itemCount,
        itemBuilder: (ctx, i) => Transform.translate(
            offset: Offset(
                widget.horizontalOffset ?? 0, widget.verticalOffset ?? 0),
            child: widget.itemBuilder?.call(ctx, i) ?? SizedBox.shrink()),
        onPageChanged: widget.onChanged,
      );
    }

    return PageView(
      pageSnapping: widget.pageSnapping ?? true,
      reverse: widget.reverse ?? false,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection ?? Axis.horizontal,
      controller: _pageController,
      onPageChanged: widget.onChanged,
      children: widget.children,
    );
  }
}
