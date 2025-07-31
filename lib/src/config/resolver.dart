import '../Utils/asset_bundle_operations.dart';
import '../Utils/download_operations.dart';
import '../Utils/file_operations.dart';
import '../core/functions/js_functions.dart';
import '../framework/utils/functional_util.dart';
import '../framework/utils/types.dart';
import '../init/flavor.dart';
import '../network/core/types.dart';
import '../network/network_client.dart';
import 'exception.dart';
import 'factory.dart';
import 'model.dart';
import 'provider.dart';

class ConfigResolver implements ConfigProvider {
  final Flavor _flavorInfo;
  final NetworkClient _networkClient;
  String? _branchName;
  JSFunctions? _functions;

  ConfigResolver(this._flavorInfo, this._networkClient);

  @override
  Future<JsonLike?> getAppConfigFromNetwork(String path) async {
    var resp = await _networkClient.requestInternal(
      HttpMethod.post,
      data: {'branchName': _branchName},
      path,
      (json) => json as dynamic,
    );
    final data = as$<JsonLike>(resp.data['response']);
    return data;
  }

  @override
  Future<void> initFunctions(
      {String? remotePath, String? localPath, int? version}) async {
    _functions = JSFunctions();
    if (remotePath != null) {
      var res =
          await _functions!.initFunctions(PreferRemote(remotePath, version));
      if (!res) {
        throw ConfigException('Functions not initialized');
      }
    }
    if (localPath != null) {
      var res = await _functions!.initFunctions(PreferLocal(localPath));
      if (!res) {
        throw ConfigException('Functions not initialized');
      }
    }
  }

  Future<DUIConfig> getConfig() async {
    final strategy = ConfigStrategyFactory.createStrategy(_flavorInfo, this);
    final config = await strategy.getConfig();
    config.jsFunctions = _functions;
    return config;
  }

  @override
  void addVersionHeader(int version) =>
      _networkClient.addVersionHeader(version);

  @override
  AssetBundleOperations get bundleOps => const AssetBundleOperationsImpl();

  @override
  FileOperations get fileOps => const FileOperationsImpl();

  @override
  FileDownloader get downloadOps => FileDownloaderImpl();

  @override
  void addBranchName(String? branchName) {
    _branchName = branchName;
  }
}
