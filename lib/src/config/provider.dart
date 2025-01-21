import '../Utils/asset_bundle_operations.dart';
import '../Utils/download_operations.dart';
import '../Utils/file_operations.dart';
import '../framework/utils/types.dart';

/// Pending: addVersion to headers.
/// - Why add version to header only in VERSIONED & RELEASE

abstract class ConfigProvider {
  Future<JsonLike?> getAppConfigFromNetwork(String path);
  Future<void> initFunctions({
    String? remotePath,
    String? localPath,
    int? version,
  });
  void addVersionHeader(int version);
  FileOperations get fileOps;
  AssetBundleOperations get bundleOps;
  FileDownloader get downloadOps;
}
