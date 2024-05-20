import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../json_widget_builder.dart';
import '../../page/props/dui_widget_json_data.dart';
import 'dezerv_flex_grid_view.dart';

class DUIDezervDialPadBuilder extends DUIWidgetBuilder {
  DUIDezervDialPadBuilder({required super.data});

  static DUIDezervDialPadBuilder? create(DUIWidgetJsonData data) {
    return DUIDezervDialPadBuilder(data: data);
  }

  final List<int> _numbersList = [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -1];

  @override
  Widget build(BuildContext context) {
    return FlexGridView(
      spacing: 0,
      itemCount: _numbersList.length,
      rowCount: 3,
      itemBuilder: (int index) => Expanded(
        child: _buildKeyPadTile(index),
      ),
    );
  }

  Widget _buildKeyPadTile(int index) {
    if (index == _numbersList.length - 1) {
      return const InkWell(
        // onTap: onBackTap,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Icon(
              Icons.chevron_left,
              color: Color(0xffE7E6E2),
            ),
          ),
        ),
      );
    } else {
      return _buildNumberTile(_numbersList[index]);
    }
  }

  Widget _buildNumberTile(int number) {
    if (number == -1) {
      return const SizedBox(
        height: 52,
        width: 120,
      );
    } else {
      return InkWell(
        // onTap: () => onNumberTap(number),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            number.toString(),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
