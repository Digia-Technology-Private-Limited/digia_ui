import '../actions/base/action_flow.dart';
import '../data_type/variable.dart';
import '../data_type/variable_json_converter.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'vw_data.dart';

class DUIPageDefinition {
  final String pageId;
  final Map<String, Variable>? pageArgDefs;
  final Map<String, Variable>? initStateDefs;
  final ({VWData? root})? layout;
  final JsonLike? pageDataSource;
  final ActionFlow? onPageLoad;
  final ActionFlow? onBackPress;

  DUIPageDefinition({
    required this.pageId,
    required this.pageArgDefs,
    required this.initStateDefs,
    required this.layout,
    required this.pageDataSource,
    required this.onPageLoad,
    required this.onBackPress,
  });

  factory DUIPageDefinition.fromJson(JsonLike json) {
    return DUIPageDefinition(
      pageId: tryKeys<String>(json, ['uid', 'pageUid', 'pageId']) ?? '',
      pageArgDefs: tryKeys<Map<String, Variable>>(
        json,
        ['inputArgs', 'pageArgDefs', 'argDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariableJsonConverter().fromJson),
      ),
      initStateDefs: tryKeys<Map<String, Variable>>(
        json,
        ['variables', 'initStateDefs'],
        parse: (p0) =>
            as$<JsonLike>(p0).maybe(const VariableJsonConverter().fromJson),
      ),
      layout: as$<JsonLike>(json.valueFor('layout.root')).maybe(
        (p0) => (root: VWData.fromJson(p0)),
      ),
      pageDataSource: as$<JsonLike>(json.valueFor('actions.onPageLoad')),
      onPageLoad: as$<JsonLike>(json.valueFor('actions.onPageLoadAction'))
          .maybe(ActionFlow.fromJson),
      onBackPress: as$<JsonLike>(json.valueFor('actions.onBackPress'))
          .maybe(ActionFlow.fromJson),
    );
  }
}
