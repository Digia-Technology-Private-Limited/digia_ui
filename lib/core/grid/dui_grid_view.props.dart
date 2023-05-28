import 'package:digia_ui/core/page/props/dui_page_props.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_grid_view.props.g.dart';

@JsonSerializable()
class DUIGridViewProps {
  String? mainAxisSpacing;
  String? crossAxisSpacing;
  int crossAxisCount = 2;
  double? childAspectRatio;
  List<PageBodyListContainer> children;

  DUIGridViewProps({this.children = const []});

  factory DUIGridViewProps.fromJson(Map<String, dynamic> json) =>
      _$DUIGridViewPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIGridViewPropsToJson(this);
}
