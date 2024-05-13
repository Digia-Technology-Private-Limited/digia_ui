import 'package:flutter/material.dart';

import '../../components/image/image.dart';
import '../../components/image/image.props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
