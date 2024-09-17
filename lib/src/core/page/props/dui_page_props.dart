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

// @JsonSerializable()
// class PageBody {
//   DUIWidgetJsonData root;

//   PageBody({required this.root});

//   factory PageBody.fromJson(Map<String, dynamic> json) =>
//       _$PageBodyFromJson(json);

//   Map<String, dynamic> toJson() => _$PageBodyToJson(this);
// }

// class PageLayoutJsonConverter
//     extends JsonConverter<PageLayoutProps?, Map<String, dynamic>?> {
//   const PageLayoutJsonConverter();
//   static final Map<String, List<DUIWidgetJsonData>> _defaultAppBarChild = {
//     'appBar': [
//       DUIWidgetJsonData(type: 'fw/app_bar', props: {'title': 'This is AppBar'})
//     ],
//   };

//   @override
//   PageLayoutProps? fromJson(Map<String, dynamic>? json) {
//     if (json == null) return null;

//     /// If empty, show a Scaffold with a Default AppBar
//     if (json.isEmpty) {
//       return PageLayoutProps(
//           root: DUIWidgetJsonData(
//               type: 'fw/scaffold', children: {..._defaultAppBarChild}));
//     }

//     if (json['root'] != null) {
//       return PageLayoutProps(root: DUIWidgetJsonData.fromJson(json['root']));
//     }

//     /// Below code is for Backward Compatibility.
//     final Map<String, List<DUIWidgetJsonData>>? appBarProps =
//         ifNotNull(json['header']?['root'] as Map<String, dynamic>?, (p0) {
//       if (p0['type'] == 'fw/appBar') {
//         return {
//           'appBar': [DUIWidgetJsonData.fromJson(p0)]
//         };
//       }

//       return null;
//     });

//     final Map<String, List<DUIWidgetJsonData>>? bodyProps =
//         ifNotNull(json['body']?['root'] as Map<String, dynamic>?, (p0) {
//       return {
//         'body': [DUIWidgetJsonData.fromJson(p0)]
//       };
//     });

//     final Map<String, List<DUIWidgetJsonData>>? persistentFooterProps =
//         ifNotNull(json['footer']?['root'] as Map<String, dynamic>?, (p0) {
//       if (p0['type'] == 'digia/floatingActionButton') {
//         return {
//           'floatingActionButton': [DUIWidgetJsonData.fromJson(p0)]
//         };
//       }

//       return null;
//     });

//     return PageLayoutProps(
//         root: DUIWidgetJsonData(type: 'fw/scaffold', children: {
//       ...?appBarProps,
//       ...?bodyProps,
//       ...?persistentFooterProps
//     }));
//   }

//   @override
//   toJson(PageLayoutProps? object) {
//     return null;
//   }
// }
