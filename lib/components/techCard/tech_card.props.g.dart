// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_card.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITechCardProps _$DUITechCardPropsFromJson(Map<String, dynamic> json) =>
    DUITechCardProps()
      ..width = (json['width'] as num).toDouble()
      ..height = (json['height'] as num).toDouble()
      ..margin = DUIInsets.fromJson(json['margin'])
      ..padding = DUIInsets.fromJson(json['padding'])
      ..spaceBtwImageAndTitle = json['spaceBtwImageAndTitle'] as String
      ..cornerRadius = DUICornerRadius.fromJson(json['cornerRadius'])
      ..image = DUIImageProps.fromJson(json['image'] as Map<String, dynamic>)
      ..title = DUITextProps.fromJson(json['title'] as Map<String, dynamic>)
      ..subText = DUITextProps.fromJson(json['subText'] as Map<String, dynamic>)
      ..bgColor = json['bgColor'] as String;

Map<String, dynamic> _$DUITechCardPropsToJson(DUITechCardProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'margin': instance.margin,
      'padding': instance.padding,
      'spaceBtwImageAndTitle': instance.spaceBtwImageAndTitle,
      'cornerRadius': instance.cornerRadius,
      'image': instance.image,
      'title': instance.title,
      'subText': instance.subText,
      'bgColor': instance.bgColor,
    };
