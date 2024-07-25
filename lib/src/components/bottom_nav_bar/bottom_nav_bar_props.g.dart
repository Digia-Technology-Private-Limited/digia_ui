// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav_bar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIBottomNavigationBarProps _$DUIBottomNavigationBarPropsFromJson(
        Map<String, dynamic> json) =>
    DUIBottomNavigationBarProps(
      duration: (json['duration'] as num?)?.toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      indicatorColor: json['indicatorColor'] as String?,
      borderShape: json['borderShape'] as String?,
      showLabels: json['showLabels'] as bool?,
      shadowColor: json['shadowColor'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      surfaceTintColor: json['surfaceTintColor'] as String?,
      overlayColor: json['overlayColor'] as String?,
    );

Map<String, dynamic> _$DUIBottomNavigationBarPropsToJson(
        DUIBottomNavigationBarProps instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'duration': instance.duration,
      'elevation': instance.elevation,
      'height': instance.height,
      'indicatorColor': instance.indicatorColor,
      'shadowColor': instance.shadowColor,
      'borderShape': instance.borderShape,
      'surfaceTintColor': instance.surfaceTintColor,
      'overlayColor': instance.overlayColor,
      'showLabels': instance.showLabels,
    };
