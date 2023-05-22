// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_card_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICardProps _$DUICardPropsFromJson(Map<String, dynamic> json) => DUICardProps()
  ..bgColor = json['bgColor'] as String
  ..height = (json['height'] as num).toDouble()
  ..width = (json['width'] as num).toDouble()
  ..contentMargin =
      DUIInsets.fromJson(json['contentMargin'] as Map<String, dynamic>)
  ..cornerRadius =
      DUICornerRadius.fromJson(json['cornerRadius'] as Map<String, dynamic>)
  ..image = DUIImageProps.fromJson(json['image'] as Map<String, dynamic>)
  ..imageMargin =
      DUIInsets.fromJson(json['imageMargin'] as Map<String, dynamic>)
  ..title = DUITextProps.fromJson(json['title'] as Map<String, dynamic>)
  ..topCrumbText =
      DUITextProps.fromJson(json['topCrumbText'] as Map<String, dynamic>)
  ..spaceBtwTopCrumbTextTitle = json['spaceBtwTopCrumbTextTitle'] as String
  ..avatarText =
      DUITextProps.fromJson(json['avatarText'] as Map<String, dynamic>)
  ..avatarImage =
      DUIImageProps.fromJson(json['avatarImage'] as Map<String, dynamic>)
  ..spaceBtwAvatarImageAndText = json['spaceBtwAvatarImageAndText'] as String;

Map<String, dynamic> _$DUICardPropsToJson(DUICardProps instance) =>
    <String, dynamic>{
      'bgColor': instance.bgColor,
      'height': instance.height,
      'width': instance.width,
      'contentMargin': instance.contentMargin,
      'cornerRadius': instance.cornerRadius,
      'image': instance.image,
      'imageMargin': instance.imageMargin,
      'title': instance.title,
      'topCrumbText': instance.topCrumbText,
      'spaceBtwTopCrumbTextTitle': instance.spaceBtwTopCrumbTextTitle,
      'avatarText': instance.avatarText,
      'avatarImage': instance.avatarImage,
      'spaceBtwAvatarImageAndText': instance.spaceBtwAvatarImageAndText,
    };
