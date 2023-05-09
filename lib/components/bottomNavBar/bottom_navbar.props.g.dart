// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_navbar.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIBottomNavbarProps _$DUIBottomNavbarPropsFromJson(
        Map<String, dynamic> json) =>
    DUIBottomNavbarProps()
      ..items = (json['items'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList()
      ..type = json['type'] as String;

Map<String, dynamic> _$DUIBottomNavbarPropsToJson(
        DUIBottomNavbarProps instance) =>
    <String, dynamic>{
      'items': instance.items,
      'type': instance.type,
    };
