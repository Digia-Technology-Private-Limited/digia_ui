import 'package:flutter/material.dart';

import 'bottom_navbar.props.dart';

class DUIBottomNavbar extends StatefulWidget {
  final DUIBottomNavbarProps props;
  final Function(int) onTap;
  const DUIBottomNavbar(this.props, this.onTap, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIBottomNavbarState();
}

class _DUIBottomNavbarState extends State<DUIBottomNavbar> {
  late DUIBottomNavbarProps props;
  _DUIBottomNavbarState();
  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: props.type == 'fixed'
            ? BottomNavigationBarType.fixed
            : BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          props.currentIndex = index;
          widget.onTap(index);
        },
        currentIndex: props.currentIndex,
        items: props.items.map((e) {
          return BottomNavigationBarItem(
            activeIcon: Icon(
              IconData(
                int.parse(e['activeIcon']!),
                fontFamily: 'MaterialIcons',
              ),
            ),
            icon: Icon(
              IconData(
                int.parse(e['icon']!),
                fontFamily: 'MaterialIcons',
              ),
            ),
            label: e['label'],
          );
        }).toList());
  }
}
