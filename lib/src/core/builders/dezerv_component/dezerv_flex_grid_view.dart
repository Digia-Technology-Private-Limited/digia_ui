import 'package:flutter/material.dart';

import 'dezerv_flex_separated.dart';

/// Used in case we want to have dynamic heights for GridView
class FlexGridView extends StatelessWidget {
  final int itemCount;
  final int rowCount;
  final Widget Function(int) itemBuilder;
  final double spacing;
  final bool shouldFillEmptySpace;
  final MainAxisAlignment mainAxisAlignment;
  final double? verticalSpacing;

  const FlexGridView({
    super.key,
    required this.itemCount,
    required this.rowCount,
    required this.itemBuilder,
    this.spacing = 10,
    this.shouldFillEmptySpace = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.verticalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final int columnCount =
        (itemCount ~/ rowCount) + (itemCount % rowCount > 0 ? 1 : 0);

    return FlexSeparated(
      spacing: verticalSpacing ?? spacing,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(
        columnCount,
        (int columnIndex) => IntrinsicHeight(
          child: FlexSeparated(
            spacing: shouldFillEmptySpace ? spacing : 0,
            children: List.generate(
              rowCount,
              (int rowIndex) {
                final int newRowIndex = (columnIndex * rowCount) + rowIndex;
                // if ends then show equal spacer to divide categories equally in row
                if (newRowIndex < itemCount) {
                  return itemBuilder(newRowIndex);
                } else if (shouldFillEmptySpace) {
                  return const Spacer();
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
