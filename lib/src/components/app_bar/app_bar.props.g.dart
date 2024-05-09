// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIAppBarProps _$DUIAppBarPropsFromJson(Map<String, dynamic> json) => DUIAppBarProps(
      title: json['title'] == null ? null : DUITextProps.fromJson(json['title']),
      shadowColor: json['shadowColor'] as String?,
      backgrounColor: json['backgrounColor'] as String?,
      iconColor: json['iconColor'] as String?,
      elevation: (json['elevation'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIAppBarPropsToJson(DUIAppBarProps instance) => <String, dynamic>{
      'title': instance.title,
      'shadowColor': instance.shadowColor,
      'backgrounColor': instance.backgrounColor,
      'iconColor': instance.iconColor,
      'elevation': instance.elevation,
    };
