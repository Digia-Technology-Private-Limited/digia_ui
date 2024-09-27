import 'package:flutter/material.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_tab_controller.dart';
import '../render_payload.dart';

class VWTabController extends VirtualStatelessWidget {
  VWTabController({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();
    return InternalTabControllerProvider(
      dynamicList: payload.eval<List>(
            props.getString('dynamicList'),
            decoder: (p0) {
              final parsed = tryJsonDecode((p0 as String?) ?? '');
              if (parsed is List) return parsed;
              return null;
            },
          ) ??
          [],
      initialIndex: payload.eval<int>(props.get('initialIndex')) ?? 0,
      child: child!.toWidget(payload),
    );
  }

  static List<dynamic>? _toDynamicList(dynamic dynamicList) {
    if (dynamicList is List) {
      return dynamicList;
    }
    if (dynamicList is! String) {
      return null;
    }
    final parsed = tryJsonDecode(dynamicList) ?? dynamicList;

    if (parsed == null) return null;

    if (parsed is! List) return null;

    return parsed;
  }
}
