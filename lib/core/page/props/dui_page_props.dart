import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
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
  late PageBody body;

  PageLayoutProps();

  factory PageLayoutProps.fromJson(Map<String, dynamic> json) =>
      _$PageLayoutPropsFromJson(json);

  Map<String, dynamic> toJson() => _$PageLayoutPropsToJson(this);
}

@JsonSerializable()
class PageBody {
  bool? allowScroll = true;
  late PageBodyList list;

  PageBody();

  factory PageBody.fromJson(Map<String, dynamic> json) =>
      _$PageBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PageBodyToJson(this);
}

@JsonSerializable()
class PageBodyList {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  DUIStyleClass? styleClass;

  List<PageBodyListContainer> children;

  PageBodyList({this.children = const []});

  factory PageBodyList.fromJson(Map<String, dynamic> json) =>
      _$PageBodyListFromJson(json);

  Map<String, dynamic> toJson() => _$PageBodyListToJson(this);
}

@JsonSerializable()
class PageBodyListContainer {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  late DUIStyleClass? styleClass;
  String? alignChild;
  late PageBodyListChild child;

  PageBodyListContainer({this.alignChild});

  factory PageBodyListContainer.fromJson(Map<String, dynamic> json) =>
      _$PageBodyListContainerFromJson(json);

  Map<String, dynamic> toJson() => _$PageBodyListContainerToJson(this);
}

@JsonSerializable()
class PageBodyListChild {
  late String type;
  late Map<String, dynamic> data;

  PageBodyListChild();

  factory PageBodyListChild.fromJson(Map<String, dynamic> json) =>
      _$PageBodyListChildFromJson(json);
  Map<String, dynamic> toJson() => _$PageBodyListChildToJson(this);
}
