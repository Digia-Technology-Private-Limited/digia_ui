import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Utils/extensions.dart';
import '../../evaluator.dart';
import '../../page/dui_page_bloc.dart';
import '../dui_animated_button_builder.dart';
import 'dezerv_flex_grid_view.dart';

class DezervDialPad extends StatefulWidget {
  const DezervDialPad({super.key, required this.props});

  final Map<String, dynamic> props;

  @override
  State<DezervDialPad> createState() => _DezervDialPadState();
}

class _DezervDialPadState extends State<DezervDialPad> {
  late String _userSelectedAmount;
  late String _maxAmountErrorText;
  late String _minAmountErrorText;
  late final num _minimumAmount;
  late final num _maximumAmount;
  late final num _defaultAmount;
  late final String _formattedMinimumAmount;
  late final String _formattedMaximumAmount;
  late bool _isValidAmount;
  late TextEditingController amountController;
  late bool _isMaximum;

  @override
  void didChangeDependencies() {
    _defaultAmount =
        eval<num>(widget.props['defaultAmount'], context: context) ?? 0;
    _minimumAmount =
        eval<num>(widget.props['minimumSipAmount'], context: context) ?? 0;
    _maxAmountErrorText =
        eval<String>(widget.props['maxAmountErrorText'], context: context) ??
            'Sorry! Amount should not be more than ₹$_maximumAmount';
    _minAmountErrorText =
        eval<String>(widget.props['minAmountErrorText'], context: context) ??
            'Sorry! Amount should be at least ₹$_minimumAmount';
    _maximumAmount =
        eval<num>(widget.props['maximumSipAmount'], context: context) ??
            1000000;
    _isValidAmount = true;
    _formattedMinimumAmount = _toCurrencyWithoutDecimal(_minimumAmount);
    _formattedMaximumAmount = _toCurrencyWithoutDecimal(_maximumAmount);
    _userSelectedAmount = _defaultAmount.toString();
    amountController = TextEditingController(
        text: _toCurrencyWithoutDecimal(
      int.parse(_userSelectedAmount),
    ).replaceFirst('₹', '₹ '));
    _isMaximum = false;
    super.didChangeDependencies();
  }

  final List<int> _numbersList = [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -1];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            TextField(
              cursorRadius: Radius.zero,
              enabled: true,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.none,
              autofocus: true,
              controller: amountController,
              textAlign: TextAlign.center,
              cursorColor: const Color(0xFFE7E6E2),
              style: GoogleFonts.inter(
                color: const Color(0xFFE7E6E2),
                fontWeight: FontWeight.w700,
                fontSize: 40,
              ),
              decoration: const InputDecoration(
                focusColor: Colors.transparent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: !_isValidAmount ? 16 : 22,
            ),
            !_isValidAmount
                ? Text(
                    _isMaximum ? _maxAmountErrorText : _minAmountErrorText,
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 255, 40, 25),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: !_isValidAmount ? 8 : 23,
            ),
            FlexGridView(
              spacing: 0,
              itemCount: _numbersList.length,
              rowCount: 3,
              itemBuilder: (int index) => Expanded(
                child: _buildKeyPadTile(index),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 56,
          child: DUIAnimatedButtonBuilder.fromProps({
            ...widget.props['confirmButton'],
            'isDisabled': !_isValidAmount
          }).build(context),
        )
      ],
    );
  }

  Widget _buildKeyPadTile(int index) {
    if (index == _numbersList.length - 1) {
      return InkWell(
        onTap: _onKeypadBackTap,
        child: const Padding(
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
        onTap: () => _onKeypadNumberTap(number),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            number.toString(),
            style: GoogleFonts.inter(
              color: const Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void _onKeypadNumberTap(int selectedNumber) {
    if (_userSelectedAmount == '0') {
      _userSelectedAmount = selectedNumber.toString();
      setState(() {
        _isMaximum = false;
        amountController.text = _toCurrencyWithoutDecimal(
          int.parse(_userSelectedAmount),
        ).replaceFirst('₹', '₹ ');
      });
    } else {
      final String tempAmount = _userSelectedAmount + selectedNumber.toString();
      if (int.parse(tempAmount) < _minimumAmount) {
        _isValidAmount = false;
        setState(() {
          _isMaximum = false;
          _userSelectedAmount = tempAmount;
          amountController.text = _toCurrencyWithoutDecimal(
            int.parse(_userSelectedAmount),
          ).replaceFirst('₹', '₹ ');
        });
      } else if (int.parse(tempAmount) > _maximumAmount) {
        setState(() {
          _isMaximum = true;
          _isValidAmount = false;
        });

        // Fluttertoast.showToast(
        //   msg: 'Maximum allowed amount is $_formattedMaximumAmount',
        //   gravity: ToastGravity.BOTTOM,
        // );
      } else {
        setState(() {
          _userSelectedAmount = tempAmount;
          amountController.text = _toCurrencyWithoutDecimal(
            int.parse(_userSelectedAmount),
          ).replaceFirst('₹', '₹ ');
          _isValidAmount = true;
        });
      }
    }
    setState(() {
      // Read the list of variables from the current page
      final bloc = context.tryRead<DUIPageBloc>();
      if (bloc == null) {
        throw 'SetStateEvent called on a widget which is not wrapped in DUIPageBloc';
      }
      final state = bloc.state;
      final variables = state.props.variables;
      variables?.entries
          .firstWhere((element) => element.key == 'selectedSipAmount')
          .value
          .set(int.parse(_userSelectedAmount));
    });
  }

  void _onKeypadBackTap() {
    if (_userSelectedAmount.length != 1) {
      _userSelectedAmount =
          _userSelectedAmount.substring(0, _userSelectedAmount.length - 1);
      setState(() {
        amountController.text = _toCurrencyWithoutDecimal(
          int.parse(_userSelectedAmount),
        ).replaceFirst('₹', '₹ ');
      });

      if ((int.parse(_userSelectedAmount) > _maximumAmount) ||
          (int.parse(_userSelectedAmount) < _minimumAmount)) {
        setState(() {
          _isValidAmount = false;
          _isMaximum = false;
        });
      } else {
        setState(() {
          _isValidAmount = true;
        });
      }
    } else {
      setState(() {
        _userSelectedAmount = '0';
        amountController.text = _toCurrencyWithoutDecimal(
          int.parse(_userSelectedAmount),
        ).replaceFirst('₹', '₹ ');
        _isValidAmount = false;
        _isMaximum = false;
      });
    }
    setState(() {
      final bloc = context.tryRead<DUIPageBloc>();
      if (bloc == null) {
        throw 'SetStateEvent called on a widget which is not wrapped in DUIPageBloc';
      }
      final state = bloc.state;
      final variables = state.props.variables;
      variables?.entries
          .firstWhere((element) => element.key == 'selectedSipAmount')
          .value
          .set(int.parse(_userSelectedAmount));
    });
  }

  /// Convert from 1,20,000.25 to 1,20,000
  String _toCurrencyWithoutDecimal(num number) {
    return NumberFormat.currency(
      decimalDigits: 0,
      locale: 'en_IN',
      symbol: '₹',
    ).format(number).replaceAll('T', 'K');
  }
}
