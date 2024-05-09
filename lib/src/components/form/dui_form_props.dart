import 'package:json_annotation/json_annotation.dart';

part 'dui_form_props.g.dart';

@JsonSerializable()
class DUIFormProps {
  late List<DUIFormChildProps> children;

  DUIFormProps();

  factory DUIFormProps.fromJson(Map<String, dynamic> json) => _$DUIFormPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFormPropsToJson(this);
}

@JsonSerializable()
class DUIFormChildProps {
  late String type;
  late Map<String, dynamic> data;

  DUIFormChildProps();

  factory DUIFormChildProps.fromJson(Map<String, dynamic> json) => _$DUIFormChildPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFormChildPropsToJson(this);
}
