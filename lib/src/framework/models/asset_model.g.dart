// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalAsset _$LocalAssetFromJson(Map<String, dynamic> json) => LocalAsset(
      sId: json['_id'] as String,
      projectId: json['projectId'] as String,
      branchId: json['branchId'] as String,
      assetType: json['assetType'] as String,
      assetData:
          LocalAssetData.fromJson(json['assetData'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$LocalAssetToJson(LocalAsset instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'projectId': instance.projectId,
      'branchId': instance.branchId,
      'assetType': instance.assetType,
      'assetData': instance.assetData,
      'createdAt': instance.createdAt,
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt,
    };

LocalAssetData _$LocalAssetDataFromJson(Map<String, dynamic> json) =>
    LocalAssetData(
      type: json['type'] as String,
      image: json['image'] == null
          ? null
          : AssetInfo.fromJson(json['image'] as Map<String, dynamic>),
      localPath: json['localPath'] as String,
    )..fileUrl = json['fileUrl'] == null
        ? null
        : AssetInfo.fromJson(json['fileUrl'] as Map<String, dynamic>);

Map<String, dynamic> _$LocalAssetDataToJson(LocalAssetData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'image': instance.image,
      'fileUrl': instance.fileUrl,
      'localPath': instance.localPath,
    };

AssetInfo _$AssetInfoFromJson(Map<String, dynamic> json) => AssetInfo(
      baseUrl: json['baseUrl'] as String,
      path: json['path'] as String,
      fileName: json['fileName'] as String?,
    );

Map<String, dynamic> _$AssetInfoToJson(AssetInfo instance) => <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'path': instance.path,
      'fileName': instance.fileName,
    };
