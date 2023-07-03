import 'package:digia_ui/Utils/util_functions.dart';

class AppBarProps {
  String? title;
  String? backgroundColor;
  double? elevation;
  bool? centerTitle;
  bool? back;
  List<dynamic>? actions;
  AppBarProps({
    this.title,
    this.backgroundColor,
    this.elevation,
    this.centerTitle,
    this.back,
    this.actions,
  });
  static AppBarProps fromJson(dynamic json) => AppBarProps(
        title: json['title'] as String,
        backgroundColor: json['backgroundColor'] as String?,
        elevation: tryParseToDouble(json['elevation']) ?? 0,
        centerTitle: json['centerTitle'] ?? false,
        back: json['back'] ?? false,
        actions: json['actions'] ?? [],
      );
}
