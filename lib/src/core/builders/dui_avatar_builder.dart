import 'package:flutter/material.dart';

import '../../components/dui_avatar/avatar.dart';
import '../../components/dui_avatar/avatar_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
