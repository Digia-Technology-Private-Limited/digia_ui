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
}
