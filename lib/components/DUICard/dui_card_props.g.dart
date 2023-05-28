// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_card_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICardProps _$DUICardPropsFromJson(Map<String, dynamic> json) => DUICardProps()
  ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
  ..contentPadding = DUIInsets.fromJson(json['contentPadding'])
  ..image = DUIImageProps.fromJson(json['image'] as Map<String, dynamic>)
  ..title = DUITextProps.fromJson(json['title'])
  ..topCrumbText = DUITextProps.fromJson(json['topCrumbText'])
  ..spaceBtwTopCrumbTextTitle = json['spaceBtwTopCrumbTextTitle'] as String
  ..avatarText = DUITextProps.fromJson(json['avatarText'])
  ..avatarImage =
      DUIImageProps.fromJson(json['avatarImage'] as Map<String, dynamic>)
  ..spaceBtwAvatarImageAndText = json['spaceBtwAvatarImageAndText'] as String;

Map<String, dynamic> _$DUICardPropsToJson(DUICardProps instance) =>
    <String, dynamic>{
      'contentPadding': instance.contentPadding,
      'image': instance.image,
      'title': instance.title,
      'topCrumbText': instance.topCrumbText,
      'spaceBtwTopCrumbTextTitle': instance.spaceBtwTopCrumbTextTitle,
      'avatarText': instance.avatarText,
      'avatarImage': instance.avatarImage,
      'spaceBtwAvatarImageAndText': instance.spaceBtwAvatarImageAndText,
    };
