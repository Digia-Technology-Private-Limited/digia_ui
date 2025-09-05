import '../framework/utils/types.dart';
import '../utils/asset_bundle_operations.dart';
import '../utils/download_operations.dart';
import '../utils/file_operations.dart';

/// Pending: addVersion to headers.
/// - Why add version to header only in VERSIONED & RELEASE

abstract class ConfigProvider {
  Future<JsonLike?> getAppConfigFromNetwork(String path);
  Future<void> initFunctions({
    String? remotePath,
    String? localPath,
    int? version,
  });
  void addBranchName(String? branchName);
  void addVersionHeader(int version);
  FileOperations get fileOps;
  AssetBundleOperations get bundleOps;
  FileDownloader get downloadOps;
}
