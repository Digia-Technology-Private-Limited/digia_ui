import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../json_widget_builder.dart';
import 'dui_icon_builder.dart';

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
    final enabled = data.props['enabled'] ?? true;
    final labelText = data.props['labelText'] as String?;
    final labelStyle =
        toTextStyle(DUITextStyle.fromJson(data.props['labelStyle']));
    final contentPadding =
        DUIDecoder.toEdgeInsets(data.props['contentPadding']);
    final prefixIcon =
        DUIIconBuilder.fromProps(props: data.props['prefixIcon']);
    final suffixIcon =
        DUIIconBuilder.fromProps(props: data.props['suffixIcon']);
    final borderRadius = DUIDecoder.toBorderRadius(data.props['borderRadius']);

    return TextField(
        style: style,
        maxLength: maxLength,
        maxLines: maxLines,
        cursorColor: cursorColor.letIfTrue(toColor),
        autofocus: autoFocus,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          contentPadding: contentPadding,
          focusColor: focusColor.letIfTrue(toColor),
          prefixIcon: prefixIcon.buildWithContainerProps(context),
          suffixIcon: suffixIcon.buildWithContainerProps(context),
          border: data.props['borderRadius'] != '0,0,0,0'
              ? OutlineInputBorder(borderRadius: borderRadius)
              : null,
        ));
  }
}
