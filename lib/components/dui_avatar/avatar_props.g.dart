part of 'avatar_props.dart';

DUIAvatarProps _$DUIAvatarPropsFromJson(Map<String, dynamic> json) {
  return DUIAvatarProps(
    backgroundColor: ColorDecoder.fromString(json['backgroundColor']),
    radius: (json['borderRadius'] as num).toDouble(),
    fallbackText: json['fallbackText'],
    image: json['image'],
  );
}

Map<String, dynamic> _$DUIAvatarPropsToJson(DUIAvatarProps avatarProps) {
  return <String, dynamic>{};
}
