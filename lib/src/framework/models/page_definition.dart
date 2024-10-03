import '../../models/variable_def.dart';
import '../actions/base/action_flow.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'vw_data.dart';

class DUIPageDefinition {
  final String pageId;
  final Map<String, VariableDef>? pageArgDefs;
  final Map<String, VariableDef>? initStateDefs;
  final ({VWData? root})? layout;
  final Map<String, ActionFlow>? actions;
  final JsonLike? pageDataSource;
  final ActionFlow? onPageLoad;
  final ActionFlow? onBackPress;

  DUIPageDefinition({
    required this.pageId,
    required this.pageArgDefs,
    required this.initStateDefs,
    required this.layout,
    required this.actions,
    required this.pageDataSource,
    required this.onPageLoad,
    required this.onBackPress,
  });

  factory DUIPageDefinition.fromJson(JsonLike json) {
    return DUIPageDefinition(
      pageId: tryKeys<String>(json, ['uid', 'pageUid', 'pageId']) ?? '',
      actions: as$<JsonLike>(json['actions'])?.map(
        (k, v) => MapEntry(k, ActionFlow.fromJson(v)),
      ),
      pageArgDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['inputArgs', 'pageArgDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariablesJsonConverter().fromJson),
      ),
      initStateDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['variables', 'initStateDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariablesJsonConverter().fromJson),
      ),
      layout: as$<JsonLike>(json.valueFor('layout.root')).maybe(
        (p0) => (root: VWNodeData.fromJson(p0)),
      ),
      pageDataSource: as$<JsonLike>(json.valueFor('actions.onPageLoad')),
      onPageLoad: as$<JsonLike>(json.valueFor('actions.onPageLoadAction'))
          .maybe(ActionFlow.fromJson),
      onBackPress: as$<JsonLike>(json.valueFor('actions.onBackPress'))
          .maybe(ActionFlow.fromJson),
    );
  }
}
