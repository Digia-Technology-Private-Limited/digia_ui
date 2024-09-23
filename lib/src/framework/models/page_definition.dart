import '../../models/variable_def.dart';
import '../actions/base/action_flow.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'vw_node_data.dart';

class DUIPageDefinition {
  final String pageId;
  final Map<String, VariableDef>? pageArgDefs;
  final Map<String, VariableDef>? initStateDefs;
  final ({VWNodeData? root})? layout;
  final Map<String, ActionFlow>? actions;

  DUIPageDefinition({
    required this.pageId,
    required this.pageArgDefs,
    required this.initStateDefs,
    required this.layout,
    required this.actions,
  });

  ActionFlow? get onPageLoad => actions?['onPageLoadAction'];
  ActionFlow? get pageDataSource => actions?['onPageLoad'];
  ActionFlow? get onBackPress => actions?['onBackPress'];

  factory DUIPageDefinition.fromJson(JsonLike json) {
    return DUIPageDefinition(
      pageId: tryKeys<String>(json, ['uid', 'pageUid', 'pageId']) ?? '',
      actions: as$<JsonLike>(json['actions'])?.map(
        (k, v) => MapEntry(k, ActionFlow.fromJson(v)),
      ),
      pageArgDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['inputArgs', 'pageArgDefs'],
        parse: (p0) => const VariablesJsonConverter().fromJson(p0),
      ),
      initStateDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['variables', 'initStateDefs'],
        parse: (p0) => const VariablesJsonConverter().fromJson(p0),
      ),
      layout: as$<JsonLike>(json.valueFor('layout.root')).maybe(
        (p0) => (root: VWNodeData.fromJson(p0)),
      ),
    );
  }
}
