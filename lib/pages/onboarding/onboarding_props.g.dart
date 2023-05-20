// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingProps _$OnBoardingPropsFromJson(Map<String, dynamic> json) =>
    OnBoardingProps()
      ..height = (json['height'] as num).toDouble()
      ..width = (json['width'] as num).toDouble()
      ..color = json['color'] as String
      ..insets = json['insets'] == null
          ? null
          : DUIInsets.fromJson(json['insets'] as Map<String, dynamic>)
      ..cornerRadius = json['cornerRadius'] == null
          ? null
          : DUICornerRadius.fromJson(
              json['cornerRadius'] as Map<String, dynamic>)
      ..logoText =
          DUITextProps.fromJson(json['logoText'] as Map<String, dynamic>)
      ..title = DUITextProps.fromJson(json['title'] as Map<String, dynamic>)
      ..subTitle =
          DUITextProps.fromJson(json['subTitle'] as Map<String, dynamic>)
      ..button = json['button'] == null
          ? null
          : DUIButtonProps.fromJson(json['button'] as Map<String, dynamic>);

Map<String, dynamic> _$OnBoardingPropsToJson(OnBoardingProps instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'color': instance.color,
      'insets': instance.insets,
      'cornerRadius': instance.cornerRadius,
      'logoText': instance.logoText,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'button': instance.button,
    };
