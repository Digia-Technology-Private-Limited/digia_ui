import 'package:flutter/material.dart';

class DUIFlexFit extends StatelessWidget {
  final int? flex;
  final String? expansionType;
  final Widget child;

  const DUIFlexFit(
      {super.key, this.expansionType, this.flex, required this.child});

  @override
  Widget build(BuildContext context) {
    if (expansionType == null) {
      return child;
    }

    switch (expansionType) {
      case 'tight':
        return Expanded(
          flex: flex ?? 1,
          child: child,
        );
      case 'loose':
        return Flexible(
          flex: flex ?? 1,
          child: child,
        );
    }

    return child;
  }
}
