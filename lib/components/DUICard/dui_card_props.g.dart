// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_card_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICardProps _$DUICardPropsFromJson(Map<String, dynamic> json) => DUICardProps()
  ..color = json['color'] as String
  ..height = (json['height'] as num).toDouble()
  ..width = (json['width'] as num).toDouble()
  ..insets = DUIInsets.fromJson(json['insets'] as Map<String, dynamic>)
  ..cornerRadius =
      DUICornerRadius.fromJson(json['cornerRadius'] as Map<String, dynamic>)
  ..thumbnail =
      DUIImageProps.fromJson(json['thumbnail'] as Map<String, dynamic>)
  ..authorProfile =
      DUIImageProps.fromJson(json['authorProfile'] as Map<String, dynamic>)
  ..date = DUITextProps.fromJson(json['date'] as Map<String, dynamic>)
  ..authorName =
      DUITextProps.fromJson(json['authorName'] as Map<String, dynamic>)
  ..title = DUITextProps.fromJson(json['title'] as Map<String, dynamic>);

Map<String, dynamic> _$DUICardPropsToJson(DUICardProps instance) =>
    <String, dynamic>{
      'color': instance.color,
      'height': instance.height,
      'width': instance.width,
      'insets': instance.insets,
      'cornerRadius': instance.cornerRadius,
      'thumbnail': instance.thumbnail,
      'authorProfile': instance.authorProfile,
      'date': instance.date,
      'authorName': instance.authorName,
      'title': instance.title,
    };
