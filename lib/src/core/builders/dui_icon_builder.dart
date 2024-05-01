import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:flutter/material.dart';

import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../../components/dui_widget_scope.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIIconBuilder extends DUIWidgetBuilder {
  DUIIconBuilder({required super.data});

  static DUIIconBuilder? create(DUIWidgetJsonData data) {
    return DUIIconBuilder(data: data);
  }

  factory DUIIconBuilder.fromProps({required Map<String, dynamic>? props}) {
    return DUIIconBuilder(
        data: DUIWidgetJsonData(type: 'digia/icon', props: props));
  }

  @override
  Widget build(BuildContext context) {
    final eval = DUIWidgetScope.of(context)!.eval;

    final props = data.props;

    if (props['iconData'] == null) {
      return const SizedBox.shrink();
    }

    final scope = DUIWidgetScope.of(context);
    var iconData = scope?.iconDataProvider?.call(props['iconData']);

    iconData ??= getIconData(icondataMap: props['iconData']);

    return Icon(iconData,
        size: eval<double>(props['iconSize']),
        color: eval<String>(props['iconColor']).let(toColor));
  }
}
