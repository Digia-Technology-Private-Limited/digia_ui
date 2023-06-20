import 'package:digia_ui/components/DUICard/dui_card.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/button/button.dart';
import 'package:digia_ui/components/charts/dui_chart.dart';
import 'package:digia_ui/components/easy-eat/chart.dart';
import 'package:digia_ui/components/form/dui_form.dart';
import 'package:digia_ui/components/form/dui_text_field.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:digia_ui/components/techCard/tech_card.dart';
import 'package:digia_ui/core/flutter_widgets.dart';
import 'package:digia_ui/core/grid/dui_grid_view.dart';
import 'package:flutter/material.dart';

typedef WidgetFromJsonFn<T extends Widget> = T Function(
    Map<String, dynamic> json);

// ignore: non_constant_identifier_names
final Map<String, WidgetFromJsonFn> DUIWidgetRegistry = {
  // 'digia/button': DUIButton.fromJson,
  'digia/text': DUIText.create,
  'digia/image': DUIImage.create,
  'digia/button': DUIButton.create,
  'digia/card_type1': DUITechCard.create,
  'digia/card_type2': DUICard.create,
  'digia/grid': DUIGridView.create,
  'digia/chart': DUIChart.create,
  'easy-eat/chart': EEChart.create,
  'fw/sized_box': FW.sizedBox,
  'fw/spacer': FW.spacer,
  'digia/form': DUIForm.create,
};

// ignore: constant_identifier_names
const Map<String, WidgetFromJsonFn> DUIFormRegistry = {
  'digia/form/textfield': DUITextField.create,
  'fw/sized_box': FW.sizedBox,
  'fw/spacer': FW.spacer
};
