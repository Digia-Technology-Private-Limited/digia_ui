import 'package:digia_ui/src/components/dui_lottie/dui_lottie.dart';
import 'package:digia_ui/src/components/dui_lottie/dui_lottie_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUILottieBuilder extends DUIWidgetBuilder {
  DUILottieBuilder({required super.data});

  static DUILottieBuilder create(DUIWidgetJsonData data) {
    return DUILottieBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUILottie(
      props: DUILottieProps.fromJson(data.props),
    );
  }
}
