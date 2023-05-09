import 'package:flutter/material.dart';

import 'bottom_navbar.props.dart';

class DUIBottomNavbar extends StatefulWidget {
  final DUIBottomNavbarProps props;

  const DUIBottomNavbar(this.props, {super.key}) : super();

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
        type: BottomNavigationBarType.fixed, items: const []);
    // return Container(
    //   margin: props.margin.margins(),
    //   child: InkWell(
    //     onTap: () {
    //       log('Button Clicked');
    //     },
    //     child: Container(
    //       alignment: Alignment.center,
    //       width: props.width,
    //       padding: props.padding.margins(),
    //       height: props.height,
    //       decoration: BoxDecoration(
    //         color: props.disabled
    //             ? Color(int.parse('0xFF${props.disabledBackgroundColor}'))
    //             : Color(int.parse('0xFF${props.backgroundColor}')),
    //         borderRadius: props.cornerRadius.getRadius(),
    //       ),
    //       child: Text(
    //         props.text,
    //         style: TextStyle(
    //           fontSize: props.fontSize ?? 14,
    //           color: props.disabled
    //               ? Color(int.parse('0xFF${props.disabledTextColor}'))
    //               : Color(int.parse('0xFF${props.textColor}')),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
