// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_button_style_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonStyleClass? _$DUIButtonStyleClassFromJson(dynamic json) {
  if (json is Map<String, dynamic> && json.isNotEmpty) {
    return _$DUIButtonStyleClassFromDirectory(json);
  }

  if (json is! String) {
    return null;
  }

  final styleClassMap = createStyleMap(json);
  if (styleClassMap.isEmpty) return null;

  return _$DUIButtonStyleClassFromDirectory(styleClassMap);
}

DUIButtonStyleClass _$DUIButtonStyleClassFromDirectory(
        Map<String, dynamic> json) =>
    DUIButtonStyleClass(
      padding:
          json['padding'] == null ? null : DUIInsets.fromJson(json['padding']),
      margin:
          json['margin'] == null ? null : DUIInsets.fromJson(json['margin']),
      bgColor: json['bgColor'] as String?,
      alignment: json['alignment'] as String?,
      elevation: (json['elevation'] as num?)?.toDouble(),
      disabledButtonStyle: json['disabledButtonStyle'] == null
          ? null
          : DUIDisabledButtonStyle.fromJson(
              json['disabledButtonStyle'] as Map<String, dynamic>),
      pressedBgColor: json['pressedBgColor'] as String?,
      shape: json['shape'] == null
          ? null
          : DUIButtonShape.fromJson(json['shape'] as Map<String, dynamic>),
      shadowColor: json['shadowColor'] as String?,
    );

Map<String, dynamic> _$DUIButtonStyleClassToJson(
        DUIButtonStyleClass instance) =>
    <String, dynamic>{
      'padding': instance.padding,
      'margin': instance.margin,
      'bgColor': instance.bgColor,
      'pressedBgColor': instance.pressedBgColor,
      'disabledButtonStyle': instance.disabledButtonStyle,
      'shape': instance.shape,
      'shadowColor': instance.shadowColor,
      'alignment': instance.alignment,
      'elevation': instance.elevation,
    };

DUIDisabledButtonStyle _$DUIDisabledButtonStyleFromJson(
        Map<String, dynamic> json) =>
    DUIDisabledButtonStyle(
      disabledBgColor: json['disabledBgColor'] as String?,
      disabledChildColor: json['disabledChildColor'] as String?,
      isDisabled: json['isDisabled'] as bool? ?? false,
    );

Map<String, dynamic> _$DUIDisabledButtonStyleToJson(
        DUIDisabledButtonStyle instance) =>
    <String, dynamic>{
      'disabledBgColor': instance.disabledBgColor,
      'disabledChildColor': instance.disabledChildColor,
      'isDisabled': instance.isDisabled,
    };
