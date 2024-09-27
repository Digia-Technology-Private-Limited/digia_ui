import 'package:json_annotation/json_annotation.dart';

import '../../../framework/models/vw_node_data.dart';
import '../../../models/variable_def.dart';
import '../../action/action_prop.dart';

part 'dui_page_props.g.dart';

@JsonSerializable()
class DUIPageProps {
  String uid;
  Map<String, ActionFlow> actions;
  @VariablesJsonConverter()
  Map<String, VariableDef>? inputArgs;
  @VariablesJsonConverter()
  Map<String, VariableDef>? variables;
  PageLayoutProps? layout;

  DUIPageProps({
    required this.uid,
    Map<String, ActionFlow>? actions,
    this.inputArgs,
    this.variables,
    required this.layout,
  }) : actions = actions ?? {};

  factory DUIPageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIPagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIPagePropsToJson(this);

  ActionFlow? get onPageLoad => actions['onPageLoadAction'];
  ActionFlow? get executeDataSource => actions['onPageLoad'];
  ActionFlow? get onBackPress => actions['onBackPress'];
}

@JsonSerializable()
class PageLayoutProps {
  VWNodeData root;

  PageLayoutProps({
    required this.root,
  });

  factory PageLayoutProps.fromJson(Map<String, dynamic> json) =>
      _$PageLayoutPropsFromJson(json);
}
