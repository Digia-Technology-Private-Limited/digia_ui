import 'package:digia_ui/src/components/image/image.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIImageBuilder extends DUIWidgetBuilder {
  DUIImageBuilder({required super.data});

  static DUIImageBuilder create(DUIWidgetJsonData data) {
    return DUIImageBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIImage(DUIImageProps.fromJson(data.props));
  }
}
