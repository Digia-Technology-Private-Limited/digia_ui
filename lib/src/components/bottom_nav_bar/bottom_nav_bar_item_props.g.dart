// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav_bar_item_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIBottomNavigationBarItemProps _$DUIBottomNavigationBarItemPropsFromJson(
        Map<String, dynamic> json) =>
    DUIBottomNavigationBarItemProps(
      label: json['label'] as String?,
      icon: json['icon'] as Map<String, dynamic>?,
      selectedIcon: json['selectedIcon'] as Map<String, dynamic>?,
      pageId: json['pageId'] as String?,
    );

Map<String, dynamic> _$DUIBottomNavigationBarItemPropsToJson(
        DUIBottomNavigationBarItemProps instance) =>
    <String, dynamic>{
      'label': instance.label,
      'icon': instance.icon,
      'selectedIcon': instance.selectedIcon,
      'pageId': instance.pageId,
    };
