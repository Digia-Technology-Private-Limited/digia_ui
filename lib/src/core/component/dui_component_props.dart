import 'package:json_annotation/json_annotation.dart';

import '../../framework/models/vw_node_data.dart';
import '../../models/variable_def.dart';
import '../action/action_prop.dart';

part 'dui_component_props.g.dart';

@JsonSerializable()
class DUIComponentProps {
  String uid;
  Map<String, ActionFlow> actions;
  @VariablesJsonConverter()
  Map<String, VariableDef>? inputArgs;
  @VariablesJsonConverter()
  Map<String, VariableDef>? variables;
  ComponentLayoutProps? layout;

  DUIComponentProps({
    required this.uid,
    Map<String, ActionFlow>? actions,
    this.inputArgs,
    this.variables,
    required this.layout,
  }) : actions = actions ?? {};

  factory DUIComponentProps.fromJson(Map<String, dynamic> json) =>
      _$DUIComponentPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIComponentPropsToJson(this);

  ActionFlow? get onComponentLoad => actions['onComponentLoad'];
  ActionFlow? get onBackPress => actions['onBackPress'];
}

@JsonSerializable()
class ComponentLayoutProps {
  VWNodeData root;

  ComponentLayoutProps({
    required this.root,
  });

  factory ComponentLayoutProps.fromJson(Map<String, dynamic> json) =>
      _$ComponentLayoutPropsFromJson(json);
}

// class ComponentLayoutJsonConverter
//     extends JsonConverter<ComponentLayoutProps?, Map<String, dynamic>?> {
//   const ComponentLayoutJsonConverter();

//   @override
//   ComponentLayoutProps? fromJson(Map<String, dynamic>? json) {
//     if (json == null) return null;

//     /// If empty, show Container with no child
//     if (json.isEmpty) {
//       return ComponentLayoutProps(
//           root: DUIWidgetJsonData(type: 'digia/container', children: {}));
//     }

//     if (json['root'] != null) {
//       return ComponentLayoutProps(
//           root: DUIWidgetJsonData.fromJson(json['root']));
//     }
//     return null;
//   }

//   @override
//   toJson(ComponentLayoutProps? object) {
//     return null;
//   }
// }
