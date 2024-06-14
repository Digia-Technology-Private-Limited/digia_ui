// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dezerv_dial_pad_widget_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DezervDialPadProps _$DezervDialPadPropsFromJson(Map<String, dynamic> json) =>
    DezervDialPadProps(
      defaultAmount: (json['defaultAmount'] as num?)?.toDouble(),
      maximumSipAmount: (json['maximumSipAmount'] as num?)?.toDouble(),
      minimumSipAmount: json['minimumSipAmount'] as num?,
    );

Map<String, dynamic> _$DezervDialPadPropsToJson(DezervDialPadProps instance) =>
    <String, dynamic>{
      'defaultAmount': instance.defaultAmount,
      'maximumSipAmount': instance.maximumSipAmount,
      'minimumSipAmount': instance.minimumSipAmount,
    };
