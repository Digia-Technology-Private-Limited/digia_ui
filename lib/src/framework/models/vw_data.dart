import 'package:collection/collection.dart';

import '../data_type/variable.dart';
import '../data_type/variable_json_converter.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'common_props.dart';
import 'props.dart';
import 'types.dart';
import 'vw_repeat_data.dart';

enum NodeType {
  widget,
  state,
  component;

  static NodeType? fromString(String value) {
    return NodeType.values.firstWhereOrNull(
      (type) => type.name == value,
    );
  }
}

sealed class VWData {
  final String? refName;

  VWData({
    required this.refName,
  });

  static VWData? fromJson(JsonLike json) {
    final nodeType = tryKeys<String>(json, ['category', 'nodeType']);
    switch (nodeType) {
      case 'widget':
        return VWNodeData.fromJson(json);

      case 'component':
        return VWComponentData.fromJson(json);

      case 'state':
        return VWStateData.fromJson(json);

      default:
        return VWNodeData.fromJson(json);
    }
  }
}

class VWComponentData extends VWData {
  final String id;
  final Map<String, ExprOr<Object>?>? args;
  final CommonProps? commonProps;
  final Props? parentProps;

  VWComponentData({
    required this.id,
    required this.args,
    required super.refName,
    required this.commonProps,
    required this.parentProps,
  });

  factory VWComponentData.fromJson(JsonLike json) {
    return VWComponentData(
      id: json['componentId'] as String,
      args: as$<JsonLike>(json['componentArgs'])
          ?.map((k, v) => MapEntry(k, ExprOr.fromJson<Object>(v))),
      refName: tryKeys<String>(json, ['varName', 'refName']),
      commonProps:
          as$<JsonLike>(json['containerProps']).maybe(CommonProps.fromJson),
      parentProps:
          as$<JsonLike>(json['parentProps']).maybe((p0) => Props(p0)) ??
              Props.empty(),
    );
  }
}

class VWStateData extends VWData {
  final Map<String, Variable> initStateDefs;
  final Map<String, List<VWData>>? childGroups;

  VWStateData({
    required super.refName,
    required this.initStateDefs,
    required this.childGroups,
  });

  factory VWStateData.fromJson(JsonLike json) {
    return VWStateData(
      initStateDefs: as$<JsonLike>(json['initStateDefs'])
              .maybe(const VariableJsonConverter().fromJson) ??
          {},
      childGroups: tryKeys(
        json,
        ['children', 'composites', 'childGroups'],
        parse: _parseVWNodeDataMap,
      ),
      refName: tryKeys<String>(json, ['varName', 'refName']),
    );
  }
}

class VWNodeData extends VWData {
  final String type;
  final Props props;
  final CommonProps? commonProps;
  final Props? parentProps;
  final Map<String, List<VWData>>? childGroups;
  final VWRepeatData? repeatData;

  VWNodeData({
    required this.type,
    required this.props,
    required this.commonProps,
    required this.parentProps,
    required this.childGroups,
    required this.repeatData,
    required super.refName,
  });

  factory VWNodeData.fromJson(Map<String, Object?> json) {
    return VWNodeData(
      type: as$<String>(json['type']) ?? '',
      props: as$<JsonLike>(json['props']).maybe((p0) => Props(p0)) ??
          Props.empty(),
      commonProps:
          as$<JsonLike>(json['containerProps']).maybe(CommonProps.fromJson),
      parentProps:
          as$<JsonLike>(json['parentProps']).maybe((p0) => Props(p0)) ??
              Props.empty(),
      childGroups: tryKeys(
        json,
        ['children', 'composites', 'childGroups'],
        parse: _parseVWNodeDataMap,
      ),
      repeatData: tryKeys(
            json,
            ['dataRef', 'repeatData'],
            parse: VWRepeatData.fromJson,
          ) ??
          (json['props'] is Map
              ? VWRepeatData.fromJson(
                  as$<JsonLike>(json['props'])?['dataSource'])
              : null),
      refName: tryKeys<String>(json, ['varName', 'refName']),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

Map<String, List<VWData>>? _parseVWNodeDataMap(Object? json) {
  final jsonMap = as$<JsonLike>(json);
  if (jsonMap == null) return null;

  return Map.fromEntries(
    jsonMap.entries.map((entry) {
      final key = entry.key;
      final value = as$<List<dynamic>>(entry.value);
      final nodeDataList = value
          ?.map((item) => as$<JsonLike>(item))
          .whereType<JsonLike>()
          .map(VWData.fromJson)
          .nonNulls
          .toList();

      return MapEntry(key, nodeDataList ?? []);
    }),
  );
}
