import 'package:digia_ui/components/dui_avatar/avatar.dart';
import 'package:digia_ui/components/dui_avatar/avatar_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIAvatarBuilder extends DUIWidgetBuilder {
  DUIAvatarBuilder({required super.data});

  static DUIAvatarBuilder create(DUIWidgetJsonData data) {
    return DUIAvatarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIAvatar(
      props: DUIAvatarProps.fromJson(data.props),
    );
  }
}
