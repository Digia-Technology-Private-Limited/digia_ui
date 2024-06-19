import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/form/dui_text_form_field.dart';
import '../json_widget_builder.dart';
import 'dui_json_widget_builder.dart';

class DUITextFormFieldBuilder extends DUIWidgetBuilder {
  DUITextFormFieldBuilder({required super.data});

  static DUITextFormFieldBuilder create(DUIWidgetJsonData data) {
    return DUITextFormFieldBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUITextFormField(
        varName: data.varName,
        props: data.props,
        prefixIcon: (data.children['prefix']?.firstOrNull).let((p0) =>
            DUIJsonWidgetBuilder(data: p0, registry: DUIWidgetRegistry.shared)
                .build(context)),
        suffixIcon: (data.children['suffix']?.firstOrNull).let((p0) =>
            DUIJsonWidgetBuilder(data: p0, registry: DUIWidgetRegistry.shared)
                .build(context)));
  }
}
