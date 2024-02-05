import 'package:digia_ui/src/core/builders/dui_app_bar_builder.dart';
import 'package:digia_ui/src/core/builders/dui_avatar_builder.dart';
import 'package:digia_ui/src/core/builders/dui_button_builder.dart';
import 'package:digia_ui/src/core/builders/dui_column_builder.dart';
import 'package:digia_ui/src/core/builders/dui_gridview_builder.dart';
import 'package:digia_ui/src/core/builders/dui_image_builder.dart';
import 'package:digia_ui/src/core/builders/dui_listview_builder.dart';
import 'package:digia_ui/src/core/builders/dui_row_builder.dart';
import 'package:digia_ui/src/core/builders/dui_sized_box_builder.dart';
import 'package:digia_ui/src/core/builders/dui_spacer_builder.dart';
import 'package:digia_ui/src/core/builders/dui_text_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../core/builders/dui_container2_builder.dart';
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
    'digia/avatar': withoutRegistry(DUIAvatarBuilder.create),
    'digia/richText': withoutRegistry(DUITextBuilder.create),
    'digia/text': withoutRegistry(DUITextBuilder.create),
    'digia/button': withoutRegistry(DUIButtonBuilder.create),
    'digia/image': withoutRegistry(DUIImageBuilder.create),
    'digia/listView': (data, {registry}) =>
        DUIListViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/gridView': (data, {registry}) =>
        DUIGridViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/column': (data, {registry}) =>
        DUIColumnBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/row': (data, {registry}) =>
        DUIRowBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/container': withoutRegistry(DUIContainer2Builder.create),
    'fw/sized_box': withoutRegistry(DUISizedBoxBuilder.create),
    'fw/spacer': withoutRegistry(DUISpacerBuilder.create),
    'fw/appBar': withoutRegistry(DUIAppBarBuilder.create),
    'fw/scaffold': withoutRegistry(DUIScaffoldBuilder.create)
  };

  static const DUIWidgetRegistry shared = DUIWidgetRegistry();

  DUIWidgetBuilder? getBuilder(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    final builderFn = builders[data.type];

    return builderFn?.call(data,
        registry: registry ?? DUIWidgetRegistry.shared);
  }
}
