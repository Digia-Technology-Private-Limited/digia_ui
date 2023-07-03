// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../Utils/util_functions.dart';

part 'dui_icon_props.json.dart';

class DUIIconProps {
  dynamic value;
  dynamic size;
  String? color;
  DUIIconProps({
    required this.value,
    this.size,
    this.color,
  });
  static DUIIconProps? fromJson(dynamic json) => _$DUIIconPropsFromJson(json);
}
