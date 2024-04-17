import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

part 'dui_page_props.g.dart';

class VariableDef {
  final String type;
  final String name;
  final Object? _defaultValue;
  Object? _value;

  Object? get value => _value;

  Object? get defaultValue => _defaultValue;

  VariableDef({required this.type, required this.name, Object? defaultValue})
      : _value = defaultValue,
        _defaultValue = defaultValue;

  void set(Object? value) {
    _value = value;
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'name': name, 'default': _defaultValue};
  }
}

@JsonSerializable()
class DUIPageProps {
  String uid;
  dynamic actions;
  dynamic inputArgs;
  @VariablesJsonConverter()
  Map<String, VariableDef>? variables;
  @PageLayoutJsonConverter()
  PageLayoutProps? layout;

  DUIPageProps({
    required this.uid,
    this.actions,
    this.inputArgs,
    this.variables,
    required this.layout,
  });

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

    return PageLayoutProps(
        root: DUIWidgetJsonData(
            type: 'fw/scaffold', children: {...?appBarProps, ...?bodyProps}));
  }

  @override
  toJson(PageLayoutProps? object) {
    return null;
  }
}

class VariablesJsonConverter
    extends JsonConverter<Map<String, VariableDef>, Map<String, dynamic>> {
  const VariablesJsonConverter();
  @override
  Map<String, VariableDef> fromJson(Map<String, dynamic>? json) {
    if (json == null) return {};

    return json.entries.fold({}, (result, curr) {
      result[curr.key] = VariableDef(
          type: curr.value['type'] as String,
          name: curr.key,
          defaultValue: curr.value['default']);
      return result;
    });
  }

  @override
  Map<String, dynamic> toJson(Map<String, VariableDef>? object) {
    if (object == null) return {};

    return object.entries.fold({}, (result, curr) {
      result[curr.key] = curr.value.toJson();
      return result;
    });
  }
}
