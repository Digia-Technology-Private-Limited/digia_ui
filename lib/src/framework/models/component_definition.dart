import '../../models/variable_def.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'vw_data.dart';

class DUIComponentDefinition {
  final String id;
  final Map<String, VariableDef>? argDefs;
  final Map<String, VariableDef>? initStateDefs;
  final ({VWData? root})? layout;

  const DUIComponentDefinition({
    required this.id,
    required this.argDefs,
    required this.initStateDefs,
    required this.layout,
  });

  factory DUIComponentDefinition.fromJson(JsonLike json) {
    return DUIComponentDefinition(
      id: tryKeys<String>(json, ['uid', 'pageUid', 'pageId']) ?? '',
      argDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['argDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariablesJsonConverter().fromJson),
      ),
      initStateDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['initStateDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariablesJsonConverter().fromJson),
      ),
      layout: as$<JsonLike>(json.valueFor('layout.root')).maybe(
        (p0) => (root: VWData.fromJson(p0)),
      ),
    );
  }
}
