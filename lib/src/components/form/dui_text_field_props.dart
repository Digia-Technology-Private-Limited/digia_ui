import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/utils/DUIBorder/dui_border.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_field_props.g.dart';

@JsonSerializable()
class DUITextFieldProps {
  late String textStyle;
  late DUITextProps label;
  late DUIBorder? border;
  late DUIBorder? focusedBorder;
  late String? hintText;
  late String? hintTextStyle;
  late String? inputType;
  late String dataKey;

  DUITextFieldProps();

  factory DUITextFieldProps.fromJson(Map<String, dynamic> json) => _$DUITextFieldPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextFieldPropsToJson(this);
}
