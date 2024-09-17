import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/type_aliases.dart';
import 'props.dart';
import 'vw_repeat_data.dart';

class VWNodeData {
  final String category;
  final String type;
  final Props props;
  final Props? commonProps;
  final Map<String, List<VWNodeData>>? childGroups;
  final VWRepeatData? repeatData;
  final String? refName;

  VWNodeData({
    required this.category,
    required this.type,
    required this.props,
    required this.commonProps,
    required this.childGroups,
    required this.repeatData,
    required this.refName,
  });

  factory VWNodeData.fromJson(Map<String, dynamic> json) {
    return VWNodeData(
        category: as$<String>(json['category']) ?? '',
        type: as$<String>(json['type']) ?? '',
        props: as$<JsonLike>(json['props']).maybe((p0) => Props(p0)) ??
            Props.empty(),
        commonProps:
            as$<JsonLike>(json['containerProps']).maybe((p0) => Props(p0)),
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
        refName: tryKeys<String>(json, ['varName', 'refName']));
  }

  static Map<String, List<VWNodeData>>? _parseVWNodeDataMap(dynamic json) {
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
