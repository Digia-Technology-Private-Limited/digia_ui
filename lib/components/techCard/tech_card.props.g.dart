// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_card.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITechCardProps _$DUITechCardPropsFromJson(Map<String, dynamic> json) =>
    DUITechCardProps()
      ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
      ..width = (json['width'] as num?)?.toDouble()
      ..height = (json['height'] as num?)?.toDouble()
      ..spaceBtwImageAndTitle = json['spaceBtwImageAndTitle'] as String
      ..image = DUIImageProps.fromJson(json['image'] as Map<String, dynamic>)
      ..title = DUITextProps.fromJson(json['title'])
      ..subText = DUITextProps.fromJson(json['subText']);

Map<String, dynamic> _$DUITechCardPropsToJson(DUITechCardProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'spaceBtwImageAndTitle': instance.spaceBtwImageAndTitle,
      'image': instance.image,
      'title': instance.title,
      'subText': instance.subText,
    };
