// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_lottie_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUILottieProps _$DUILottiePropsFromJson(Map<String, dynamic> json) =>
    DUILottieProps(
      lottiePath: json['lottiePath'] as String?,
      fit: json['fit'] as String?,
      alignment: json['alignment'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      frameRate: (json['frameRate'] as num?)?.toDouble(),
      reverse: json['reverse'] as bool?,
      animate: json['animate'] as bool?,
      repeat: json['repeat'] as bool?,
    );

Map<String, dynamic> _$DUILottiePropsToJson(DUILottieProps instance) =>
    <String, dynamic>{
      'lottiePath': instance.lottiePath,
      'fit': instance.fit,
      'alignment': instance.alignment,
      'height': instance.height,
      'width': instance.width,
      'frameRate': instance.frameRate,
      'reverse': instance.reverse,
      'animate': instance.animate,
      'repeat': instance.repeat,
    };
