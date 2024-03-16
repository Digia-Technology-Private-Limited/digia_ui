import 'package:digia_ui/src/core/builders/dui_app_bar_builder.dart';
import 'package:digia_ui/src/core/builders/dui_avatar_builder.dart';
import 'package:digia_ui/src/core/builders/dui_button_builder.dart';
import 'package:digia_ui/src/core/builders/dui_flex_builder.dart';
import 'package:digia_ui/src/core/builders/dui_gridview_builder.dart';
import 'package:digia_ui/src/core/builders/dui_image_builder.dart';
import 'package:digia_ui/src/core/builders/dui_listview_builder.dart';
import 'package:digia_ui/src/core/builders/dui_sized_box_builder.dart';
import 'package:digia_ui/src/core/builders/dui_spacer_builder.dart';
import 'package:digia_ui/src/core/builders/dui_stack_builder.dart';
import 'package:digia_ui/src/core/builders/dui_text_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../core/builders/dui_container2_builder.dart';
import '../core/builders/dui_htmlview_builder.dart';
import '../core/builders/dui_icon_builder.dart';
import '../core/builders/dui_scaffold_builder.dart';

typedef WidgetFromJsonFn<T extends Widget> = T Function(
    Map<String, dynamic> json);

typedef DUIWidgetBuilderCreatorFn = DUIWidgetBuilder?
    Function(DUIWidgetJsonData data, {DUIWidgetRegistry? registry});

typedef DUIWidgetBuilderWithoutRegistryCreatorFn = DUIWidgetBuilder? Function(
    DUIWidgetJsonData data);

DUIWidgetBuilderCreatorFn withoutRegistry(
        DUIWidgetBuilderWithoutRegistryCreatorFn fn) =>
    (data, {registry}) {
      return fn(data);
    };

class DUIWidgetRegistry {
  const DUIWidgetRegistry();
  static final Map<String, DUIWidgetBuilderCreatorFn> builders = {
    'digia/icon': withoutRegistry(DUIIconBuilder.create),
    'digia/htmlView': withoutRegistry(DUIHtmlViewBuilder.create),
    'digia/avatar': withoutRegistry(DUIAvatarBuilder.create),
    'digia/richText': withoutRegistry(DUITextBuilder.create),
    'digia/text': withoutRegistry(DUITextBuilder.create),
    'digia/button': withoutRegistry(DUIButtonBuilder.create),
    'digia/image': withoutRegistry(DUIImageBuilder.create),
    'digia/listView': (data, {registry}) =>
        DUIListViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/gridView': (data, {registry}) =>
        DUIGridViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/column': (data, {registry}) => DUIFlexBuilder.create(data,
        registry: DUIWidgetRegistry.shared, direction: Axis.vertical),
    'digia/row': (data, {registry}) => DUIFlexBuilder.create(data,
        registry: DUIWidgetRegistry.shared, direction: Axis.horizontal),
    'digia/container': withoutRegistry(DUIContainer2Builder.create),
    'fw/sized_box': withoutRegistry(DUISizedBoxBuilder.create),
    'fw/spacer': withoutRegistry(DUISpacerBuilder.create),
    'fw/appBar': withoutRegistry(DUIAppBarBuilder.create),
    'fw/scaffold': withoutRegistry(DUIScaffoldBuilder.create),
    'digia/stack': (data, {registry}) => DUIStackBuilder.create(data),
  };

  static const DUIWidgetRegistry shared = DUIWidgetRegistry();

  DUIWidgetBuilder? getBuilder(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    final builderFn = builders[data.type];

    return builderFn?.call(data,
        registry: registry ?? DUIWidgetRegistry.shared);
  }
}
