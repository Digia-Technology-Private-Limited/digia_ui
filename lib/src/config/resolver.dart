import '../Utils/asset_bundle_operations.dart';
import '../Utils/download_operations.dart';
import '../Utils/file_operations.dart';
import '../core/functions/js_functions.dart';
import '../digia_ui_client.dart';
import '../environment.dart';
import '../framework/utils/functional_util.dart';
import '../framework/utils/types.dart';
import '../network/core/types.dart';
import 'exception.dart';
import 'factory.dart';
import 'model.dart';
import 'provider.dart';

class ConfigResolver implements ConfigProvider {
  final FlavorInfo _flavorInfo;

  ConfigResolver(this._flavorInfo);

  @override
  Future<JsonLike?> getAppConfigFromNetwork(String path) async {
    var resp = await DigiaUIClient.instance.networkClient.requestInternal(
      HttpMethod.post,
      path,
      (json) => json as dynamic,
    );
    final data = as$<JsonLike>(resp.data['response']);
    return data;
  }

  @override
  Future<void> initFunctions(
      {String? remotePath, String? localPath, int? version}) async {
    if (remotePath != null) {
      var jsFunctions = JSFunctions();
      var res =
          await jsFunctions.initFunctions(PreferRemote(remotePath, version));
      if (!res) {
        throw ConfigException('Functions not initialized');
      }
      DigiaUIClient.instance.jsFunctions = jsFunctions;
    }
    if (localPath != null) {
      var jsFunctions = JSFunctions();
      var res = await jsFunctions.initFunctions(PreferLocal(localPath));
      if (!res) {
        throw ConfigException('Functions not initialized');
      }
      DigiaUIClient.instance.jsFunctions = jsFunctions;
    }
  }

  Future<DUIConfig> getConfig() async {
    final strategy = ConfigStrategyFactory.createStrategy(_flavorInfo, this);
    return await strategy.getConfig();
  }

  @override
  void addVersionHeader(int version) =>
      DigiaUIClient.instance.networkClient.addVersionHeader(version);

  @override
  AssetBundleOperations get bundleOps => const AssetBundleOperationsImpl();

  @override
  FileOperations get fileOps => const FileOperationsImpl();

  @override
  FileDownloader get downloadOps => FileDownloaderImpl();
}
