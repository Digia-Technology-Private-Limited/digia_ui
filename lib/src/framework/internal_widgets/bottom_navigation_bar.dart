import 'package:flutter/material.dart';

class BottomNavigationBar extends StatefulWidget {
  final Color? backgroundColor;
  final Duration? animationDuration;
  final int selectedIndex;
  final List<Widget> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final Color? surfaceTintColor;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final double? height;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final WidgetStateProperty<Color?>? overlayColor;
  final List<BoxShadow>? shadow;
  final BorderRadius? borderRadius;

  const BottomNavigationBar({
    super.key,
    this.backgroundColor,
    this.animationDuration,
    this.selectedIndex = 0,
    required this.destinations,
    this.onDestinationSelected,
    this.borderRadius,
    this.shadow,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.height,
    this.labelBehavior,
    this.overlayColor,
  });

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int _selectedIndex = 0;

  void _handleDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (widget.onDestinationSelected != null) {
      widget.onDestinationSelected!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: widget.shadow),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: NavigationBar(
          backgroundColor: widget.backgroundColor,
          animationDuration: widget.animationDuration,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _handleDestinationSelected,
          surfaceTintColor: widget.surfaceTintColor,
          indicatorColor: widget.indicatorColor,
          indicatorShape: widget.indicatorShape,
          height: widget.height,
          labelBehavior: widget.labelBehavior,
          overlayColor: widget.overlayColor,
          destinations: widget.destinations,
        ),
      ),
    );
  }
}
