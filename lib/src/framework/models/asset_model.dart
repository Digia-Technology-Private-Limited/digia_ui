import 'package:json_annotation/json_annotation.dart';

part 'asset_model.g.dart';

@JsonSerializable()
class LocalAsset {
  @JsonKey(name: '_id')
  String sId;
  String projectId;
  String branchId;
  String assetType;
  LocalAssetData assetData;
  String createdAt;
  String? createdBy;
  String updatedAt;

  LocalAsset({
    required this.sId,
    required this.projectId,
    required this.branchId,
    required this.assetType,
    required this.assetData,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

//
  factory LocalAsset.fromJson(Map<String, dynamic> json) =>
      _$LocalAssetFromJson(json);

  Map<String, dynamic> toJson() => _$LocalAssetToJson(this);
}

@JsonSerializable()
class LocalAssetData {
  String type;
  AssetInfo? image;
  AssetInfo? fileUrl;
  String localPath;

  LocalAssetData(
      {required this.type, required this.image, required this.localPath});

  factory LocalAssetData.fromJson(Map<String, dynamic> json) =>
      _$LocalAssetDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocalAssetDataToJson(this);
}

@JsonSerializable()
class AssetInfo {
  String baseUrl;
  String path;
  String? fileName;

  AssetInfo({required this.baseUrl, required this.path, this.fileName});

  factory AssetInfo.fromJson(Map<String, dynamic> json) =>
      _$AssetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetInfoToJson(this);
}
