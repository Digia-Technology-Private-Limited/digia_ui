import 'package:flutter/material.dart';

class FlexSeparated extends StatelessWidget {
  final Axis direction;
  final double spacing;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Widget? separator;

  const FlexSeparated({
    super.key,
    this.direction = Axis.horizontal,
    this.children = const [],
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.separator,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildrenWithSeparator(),
    );
  }

  List<Widget> _buildChildrenWithSeparator() {
    Widget separatorWidget;
    if (separator != null) {
      separatorWidget = separator ?? const SizedBox();
    } else if (direction == Axis.horizontal) {
      separatorWidget = SizedBox(width: spacing);
    } else {
      separatorWidget = SizedBox(height: spacing);
    }

    final List<Widget> childrenWithSeparatorList = [];
    final actualChildrenLength = children.length - 1;
    for (int i = 0; i <= actualChildrenLength; i++) {
      childrenWithSeparatorList.add(children[i]);
      if (i != actualChildrenLength) {
        childrenWithSeparatorList.add(separatorWidget);
      }
    }
    return childrenWithSeparatorList;
  }
}
