import 'package:json_annotation/json_annotation.dart';

part 'dui_widget_json_data.g.dart';

@JsonSerializable()
class DUIWidgetJsonData {
  String type;
  Map<String, dynamic> _props;
  Map<String, dynamic> _containerProps;
  List<DUIWidgetJsonData> _children;

  Map<String, dynamic> get props => _props;
  Map<String, dynamic> get containerProps => _containerProps;
  List<DUIWidgetJsonData> get children => _children;

  DUIWidgetJsonData({
    required this.type,
    Map<String, dynamic>? props,
    Map<String, dynamic>? containerProps,
    List<DUIWidgetJsonData>? children,
  })  : _props = props ?? {},
        _containerProps = containerProps ?? {},
        _children = children ?? [];

  factory DUIWidgetJsonData.fromJson(Map<String, dynamic> json) =>
      _$DUIWidgetJsonDataFromJson(json);

  Map<String, dynamic> toJson() => _$DUIWidgetJsonDataToJson(this);
}
