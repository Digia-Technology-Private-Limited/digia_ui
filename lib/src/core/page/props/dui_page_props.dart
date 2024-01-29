import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_page_props.g.dart';

@JsonSerializable()
class DUIPageProps {
  String uid;
  dynamic actions;
  dynamic inputArgs;
  PageLayoutProps? layout;

  DUIPageProps({
    required this.uid,
    this.actions,
    this.inputArgs,
    required this.layout,
  });

  factory DUIPageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIPagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIPagePropsToJson(this);
}

@JsonSerializable()
class PageLayoutProps {
  ({DUIWidgetJsonData? root})? header;
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
