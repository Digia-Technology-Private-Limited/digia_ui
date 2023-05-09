// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_card.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITechCardProps _$DUITechCardPropsFromJson(Map<String, dynamic> json) =>
    DUITechCardProps()
      ..width = (json['width'] as num).toDouble()
      ..height = (json['height'] as num).toDouble()
      ..margin = DUIInsets.fromJson(json['margin'] as Map<String, dynamic>)
      ..padding = DUIInsets.fromJson(json['padding'] as Map<String, dynamic>)
      ..cornerRadius =
          DUICornerRadius.fromJson(json['cornerRadius'] as Map<String, dynamic>)
      ..image = DUIImageProps.fromJson(json['image'] as Map<String, dynamic>)
      ..text1Color = json['text1Color'] as String
      ..text1 = json['text1'] as String
      ..text2 = json['text2'] as String
      ..text2Color = json['text2Color'] as String
      ..backgroundColor = json['backgroundColor'] as String
      ..font1Size = (json['font1Size'] as num?)?.toDouble()
      ..font2Size = (json['font2Size'] as num?)?.toDouble();

Map<String, dynamic> _$DUITechCardPropsToJson(DUITechCardProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'margin': instance.margin,
      'padding': instance.padding,
      'cornerRadius': instance.cornerRadius,
      'image': instance.image,
      'text1Color': instance.text1Color,
      'text1': instance.text1,
      'text2': instance.text2,
      'text2Color': instance.text2Color,
      'backgroundColor': instance.backgroundColor,
      'font1Size': instance.font1Size,
      'font2Size': instance.font2Size,
    };
