import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/components/dui_stack/dui_stack_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../components/utils/DUIInsets/dui_insets.dart';

class DUIStackBuilder extends DUIWidgetBuilder {
  DUIStackBuilder({required super.data});

  static DUIStackBuilder create(DUIWidgetJsonData data) {
    return DUIStackBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final props = DUIStackProps.fromJson(data.props);
    final children = data.children['children'] ?? [];

    return Stack(
      alignment: DUIDecoder.toStackChildAlignment(props.childAlignment),
      fit: DUIDecoder.toStackFit(props.fit),
      children: !children.isNullOrEmpty
          ? children.map((e) {
              DUIInsets position = DUIInsets.fromJson(
                e.containerProps.valueFor(keyPath: 'positioned.position'),
              );
              final hasPosition = e.containerProps
                      .valueFor(keyPath: 'positioned.hasPosition') ??
                  false;
              final childWidget = DUIWidget(data: e);

              if (!hasPosition) {
                return childWidget;
              }

              return Positioned(
                top: double.tryParse(position.top),
                bottom: double.tryParse(position.bottom),
                left: double.tryParse(position.left),
                right: double.tryParse(position.right),
                child: DUIWidget(
                  data: e,
                ),
              );
            }).toList()
          : [
              const Text(
                'Children field is Empty!',
                textAlign: TextAlign.center,
              ),
            ],
    );
  }
}
