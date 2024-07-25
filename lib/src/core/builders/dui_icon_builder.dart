import 'package:flutter/material.dart';

import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../../components/dui_widget_scope.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIIconBuilder extends DUIWidgetBuilder {
  DUIIconBuilder({required super.data});

  static DUIIconBuilder? create(DUIWidgetJsonData data) {
    return DUIIconBuilder(data: data);
  }

  static DUIIconBuilder? fromProps({required dynamic props}) {
    if (props == null) return null;

    if (props is! Map<String, dynamic>) return null;

    if (props['iconData'] == null) return null;

    return DUIIconBuilder(
        data: DUIWidgetJsonData(type: 'digia/icon', props: props));
  }

  static Widget emptyIconWidget() => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final props = data.props;

    if (props['iconData'] == null) {
      return const SizedBox.shrink();
    }

    final scope = DUIWidgetScope.maybeOf(context);
    var iconData = scope?.iconDataProvider?.call(props['iconData']);

    iconData ??= getIconData(icondataMap: props['iconData']);

    return Icon(
      iconData,
      size: eval<double>(props['iconSize'], context: context),
      color: makeColor(
        eval<String>(props['iconColor'], context: context),
      ),
    );
  }
}
