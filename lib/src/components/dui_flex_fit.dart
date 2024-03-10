import 'package:flutter/material.dart';

class DUIFlexFit extends StatelessWidget {
  final int? flex;
  final String? flexFit;
  final Widget child;

  const DUIFlexFit({super.key, this.flexFit, this.flex, required this.child});

  @override
  Widget build(BuildContext context) {
    if (flexFit == null) {
      return child;
    }

    switch (flexFit) {
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
