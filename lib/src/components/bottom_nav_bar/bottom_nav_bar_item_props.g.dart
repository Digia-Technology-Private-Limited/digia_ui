// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav_bar_item_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIBottomNavigationBarItemProps _$DUIBottomNavigationBarItemPropsFromJson(
        Map<String, dynamic> json) =>
    DUIBottomNavigationBarItemProps(
      labelText: json['labelText'] as Map<String, dynamic>?,
      icon: json['icon'] as Map<String, dynamic>?,
      selectedIcon: json['selectedIcon'] as Map<String, dynamic>?,
      pageId: json['pageId'] as String?,
      onPageSelected: json['onPageSelected'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DUIBottomNavigationBarItemPropsToJson(
        DUIBottomNavigationBarItemProps instance) =>
    <String, dynamic>{
      'labelText': instance.labelText,
      'icon': instance.icon,
      'selectedIcon': instance.selectedIcon,
      'pageId': instance.pageId,
      'onPageSelected': instance.onPageSelected,
    };
