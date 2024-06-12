import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUITextFieldBuilder extends DUIWidgetBuilder {
  DUITextFieldBuilder({required super.data});

  static DUITextFieldBuilder create(DUIWidgetJsonData data) {
    return DUITextFieldBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final style =
        toTextStyle(DUITextStyle.fromJson(data.props['inputTextStyle']));
    final maxLength = data.props['maxLength'];
    final hintText = data.props['hintText'];
    final maxLines = data.props['maxLines'];
    final cursorColor = data.props['cursorColor'] as String?;
    final autoFocus = data.props['autoFocus'] ?? false;
    final focusColor = data.props['focusColor'] as String?;
    final fillColor = data.props['fillColor'] as String?;
    final enabled = data.props['enabled'] ?? true;
    final labelText = data.props['labelText'] as String?;
    final labelStyle =
        toTextStyle(DUITextStyle.fromJson(data.props['labelStyle']));
    final contentPadding =
        DUIDecoder.toEdgeInsets(data.props['contentPadding']);

    return TextField(
      style: style,
      maxLength: maxLength,
      maxLines: maxLines,
      cursorColor: cursorColor.letIfTrue(toColor),
      autofocus: autoFocus,
      enabled: enabled,
      decoration: InputDecoration(
        fillColor: fillColor.letIfTrue(toColor),
        filled: eval<bool>(data.props['filled'], context: context),
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        contentPadding: contentPadding,
        focusColor: focusColor.letIfTrue(toColor),
        prefixIcon: data.children['prefix']?.first != null
            ? DUIWidget(data: data.children['prefix']!.first)
            : null,
        suffixIcon: data.children['suffix']?.first != null
            ? DUIWidget(data: data.children['suffix']!.first)
            : null,
        enabledBorder: data.props['enabledBorder'] != null
            ? getInputBorder('enabledBorder', context)
            : null,
        disabledBorder: data.props['disabledBorder'] != null
            ? getInputBorder('disabledBorder', context)
            : null,
        focusedBorder: data.props['focusedBorder'] != null
            ? getInputBorder('focusedBorder', context)
            : null,
        focusedErrorBorder: data.props['focusedErrorBorder'] != null
            ? getInputBorder('focusedErrorBorder', context)
            : null,
        errorBorder: data.props['errorBorder'] != null
            ? getInputBorder('errorBorder', context)
            : null,
      ),
    );
  }

  InputBorder getInputBorder(String border, BuildContext context) {
    BorderRadius borderRadius = DUIDecoder.toBorderRadius(
      eval<String>(
        data.props['enabledBorder']['borderRadius'],
        context: context,
      ),
    );
    String borderType =
        eval<String>(data.props[border]['borderType'], context: context) ?? '';
    BorderSide borderSide = BorderSide(
      color: eval<String>(data.props[border]['borderColor'], context: context)
              .letIfTrue(toColor) ??
          Colors.black,
      width: eval<num>(data.props[border]['borderWidth'], context: context)
              ?.toDouble() ??
          1,
      style:
          eval<String>(data.props[border]['borderStyle'], context: context) ==
                  'solid'
              ? BorderStyle.solid
              : BorderStyle.none,
    );
    switch (borderType) {
      case 'outlineInputBorder':
        return OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      case 'underlineInputBorder':
        return UnderlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      default:
        return InputBorder.none;
    }
  }
}
