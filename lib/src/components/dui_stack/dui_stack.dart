import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/components/dui_stack/dui_stack_props.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIStack extends StatelessWidget {
  final DUIStackProps props;
  final List<DUIWidgetJsonData>? children;

  const DUIStack({super.key, required this.props, this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
          alignment:
              DUIDecoder.toStackChildAlignment(props.childAlignment ?? ''),
          fit: DUIDecoder.toStackFit(props.fit ?? ''),
          children: children!.map((e) {
            DUIInsets position = DUIInsets.fromJson(
              e.containerProps.valueFor(keyPath: 'positioned.position'),
            );
            return (e.containerProps
                        .valueFor(keyPath: 'positioned.hasPosition') ??
                    false)
                ? Positioned(
                    top: double.tryParse(position.top),
                    bottom: double.tryParse(position.bottom),
                    left: double.tryParse(position.left),
                    right: double.tryParse(position.right),
                    child: DUIWidget(
                      data: e,
                    ),
                  )
                : DUIWidget(data: e);
          }).toList()),
    );
  }
}
