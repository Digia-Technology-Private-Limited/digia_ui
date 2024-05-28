import 'package:json_annotation/json_annotation.dart';

import '../../../Utils/basic_shared_utils/lodash.dart';
import '../../../models/variable_def.dart';
import '../../action/action_prop.dart';
import 'dui_widget_json_data.dart';

part 'dui_page_props.g.dart';

@JsonSerializable()
class DUIPageProps {
  String uid;
  Map<String, ActionFlow> actions;
  @VariablesJsonConverter()
  Map<String, VariableDef>? inputArgs;
  @VariablesJsonConverter()
  Map<String, VariableDef>? variables;
  @PageLayoutJsonConverter()
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
}

class PageLayoutProps {
  DUIWidgetJsonData root;

  PageLayoutProps({
    required this.root,
  });
}

@JsonSerializable()
class PageBody {
  DUIWidgetJsonData root;

  PageBody({required this.root});

  factory PageBody.fromJson(Map<String, dynamic> json) =>
      _$PageBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PageBodyToJson(this);
}

class PageLayoutJsonConverter
    extends JsonConverter<PageLayoutProps?, Map<String, dynamic>?> {
  const PageLayoutJsonConverter();
  static final Map<String, List<DUIWidgetJsonData>> _defaultAppBarChild = {
    'appBar': [
      DUIWidgetJsonData(type: 'fw/app_bar', props: {'title': 'This is AppBar'})
    ],
  };

  @override
  PageLayoutProps? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    /// If empty, show a Scaffold with a Default AppBar
    if (json.isEmpty) {
      return PageLayoutProps(
          root: DUIWidgetJsonData(
              type: 'fw/scaffold', children: {..._defaultAppBarChild}));
    }

    if (json['root'] != null) {
      return PageLayoutProps(root: DUIWidgetJsonData.fromJson(json['root']));
    }

    /// Below code is for Backward Compatibility.
    final Map<String, List<DUIWidgetJsonData>>? appBarProps =
        ifNotNull(json['header']?['root'] as Map<String, dynamic>?, (p0) {
      if (p0['type'] == 'fw/appBar') {
        return {
          'appBar': [DUIWidgetJsonData.fromJson(p0)]
        };
      }

      return null;
    });

    final Map<String, List<DUIWidgetJsonData>>? bodyProps =
        ifNotNull(json['body']?['root'] as Map<String, dynamic>?, (p0) {
      return {
        'body': [DUIWidgetJsonData.fromJson(p0)]
      };
    });

    final Map<String, List<DUIWidgetJsonData>>? persistentFooterProps =
        ifNotNull(json['footer']?['root'] as Map<String, dynamic>?, (p0) {
      if (p0['type'] == 'digia/floatingActionButton') {
        return {
          'floatingActionButton': [DUIWidgetJsonData.fromJson(p0)]
        };
      }

      return null;
    });

    return PageLayoutProps(
        root: DUIWidgetJsonData(type: 'fw/scaffold', children: {
      ...?appBarProps,
      ...?bodyProps,
      ...?persistentFooterProps
    }));
  }

  @override
  toJson(PageLayoutProps? object) {
    return null;
  }
}
