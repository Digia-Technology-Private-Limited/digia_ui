import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_page_props.g.dart';

@JsonSerializable()
class DUIPageProps {
  late String id;
  late String name;
  late dynamic actions;
  late PageLayoutProps layout;

  DUIPageProps();

  factory DUIPageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIPagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIPagePropsToJson(this);
}

@JsonSerializable()
class PageLayoutProps {
  Map<String, dynamic>? header;
  PageBody body;

  PageLayoutProps({
    this.header,
    required this.body,
  });

  factory PageLayoutProps.fromJson(Map<String, dynamic> json) =>
      _$PageLayoutPropsFromJson(json);

  Map<String, dynamic> toJson() => _$PageLayoutPropsToJson(this);
}

@JsonSerializable()
class PageBody {
  DUIWidgetJsonData root;

  PageBody({required this.root});

  factory PageBody.fromJson(Map<String, dynamic> json) =>
      _$PageBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PageBodyToJson(this);
}
