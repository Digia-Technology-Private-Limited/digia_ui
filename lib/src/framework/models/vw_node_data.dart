import '../../models/variable_def.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'common_props.dart';
import 'props.dart';
import 'vw_repeat_data.dart';

class VWNodeData {
  final String category;
  final String type;
  final Props props;
  final CommonProps? commonProps;
  final Map<String, List<VWNodeData>>? childGroups;
  final VWRepeatData? repeatData;
  final String? refName;
  final Map<String, VariableDef> initStateDefs;

  VWNodeData({
    required this.category,
    required this.type,
    required this.props,
    required this.commonProps,
    required this.childGroups,
    required this.repeatData,
    required this.refName,
    required this.initStateDefs,
  });

  factory VWNodeData.fromJson(Map<String, Object?> json) {
    return VWNodeData(
      category: as$<String>(json['category']) ?? '',
      type: as$<String>(json['type']) ?? '',
      props: as$<JsonLike>(json['props']).maybe((p0) => Props(p0)) ??
          Props.empty(),
      commonProps:
          as$<JsonLike>(json['containerProps']).maybe(CommonProps.fromJson),
      childGroups: tryKeys(
        json,
        ['children', 'composites', 'childGroups'],
        parse: _parseVWNodeDataMap,
      ),
      repeatData: tryKeys(
        json,
        ['dataRef', 'repeatData'],
        parse: VWRepeatData.fromJson,
      ),
      refName: tryKeys<String>(json, ['varName', 'refName']),
      initStateDefs: as$<JsonLike>(json['initStateDefs'])
              .maybe(const VariablesJsonConverter().fromJson) ??
          {},
    );
  }

  static Map<String, List<VWNodeData>>? _parseVWNodeDataMap(Object? json) {
    final jsonMap = as$<JsonLike>(json);
    if (jsonMap == null) return null;

    return Map.fromEntries(
      jsonMap.entries.map((entry) {
        final key = entry.key;
        final value = as$<List>(entry.value);
        final nodeDataList = value
            ?.map((item) => as$<JsonLike>(item))
            .whereType<JsonLike>()
            .map(VWNodeData.fromJson)
            .toList();

        return MapEntry(key, nodeDataList ?? []);
      }),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
