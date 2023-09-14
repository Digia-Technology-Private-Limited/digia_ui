import 'package:digia_ui/core/builders/dui_button_builder.dart';
import 'package:digia_ui/core/builders/dui_column_builder.dart';
import 'package:digia_ui/core/builders/dui_image_builder.dart';
import 'package:digia_ui/core/builders/dui_listview_builder.dart';
import 'package:digia_ui/core/builders/dui_sized_box_builder.dart';
import 'package:digia_ui/core/builders/dui_spacer_builder.dart';
import 'package:digia_ui/core/builders/dui_text_builder.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

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
  static final Map<String, DUIWidgetBuilderCreatorFn> builders = {
    'digia/text': withoutRegistry(DUITextBuilder.create),
    'digia/button': withoutRegistry(DUIButtonBuilder.create),
    'digia/image': withoutRegistry(DUIImageBuilder.create),
    'digia/listView': DUIListViewBuilder.create,
    'digia/column': DUIColumnBuilder.create,
    'fw/sized_box': withoutRegistry(DUISizedBoxBuilder.create),
    'fw/spacer': withoutRegistry(DUISpacerBuilder.create)
  };

  static final DUIWidgetRegistry shared = DUIWidgetRegistry();

  DUIWidgetBuilder? getBuilder(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    final builderFn = builders[data.type];

    return builderFn?.call(data,
        registry: registry ?? DUIWidgetRegistry.shared);
  }
}
