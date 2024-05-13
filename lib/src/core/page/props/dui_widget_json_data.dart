import 'package:json_annotation/json_annotation.dart';

part 'dui_widget_json_data.g.dart';

@JsonSerializable()
class DUIWidgetJsonData {
  String type;
  Map<String, dynamic> _props;
  Map<String, dynamic> _containerProps;
  @JsonKey(fromJson: _childrenFromJson)
  Map<String, List<DUIWidgetJsonData>> children;
  Map<String, dynamic> _dataRef;

  Map<String, dynamic> get props => _props;
  Map<String, dynamic> get containerProps => _containerProps;
  Map<String, dynamic> get dataRef => _dataRef;

  DUIWidgetJsonData({
    required this.type,
    Map<String, dynamic>? props,
    Map<String, dynamic>? containerProps,
    Map<String, List<DUIWidgetJsonData>>? children,
    Map<String, dynamic>? dataRef,
  })  : _props = props ?? {},
        _containerProps = containerProps ?? {},
        _dataRef = dataRef ?? {},
        children = children ?? <String, List<DUIWidgetJsonData>>{};

  factory DUIWidgetJsonData.fromJson(Map<String, dynamic> json) =>
      _$DUIWidgetJsonDataFromJson(json);

  Map<String, dynamic> toJson() => _$DUIWidgetJsonDataToJson(this);

  static Map<String, List<DUIWidgetJsonData>> _childrenFromJson(dynamic json) {
    if (json is List) {
      return {
        'children': json
            .map((e) => DUIWidgetJsonData.fromJson(e as Map<String, dynamic>))
            .toList()
      };
    }

    if (json is Map) {
      return json.map<String, List<DUIWidgetJsonData>>((key, value) => MapEntry(
          key as String,
          value
              .map<DUIWidgetJsonData>(
                  (e) => DUIWidgetJsonData.fromJson(e as Map<String, dynamic>))
              .toList()));
    }

    return <String, List<DUIWidgetJsonData>>{};
  }
}
