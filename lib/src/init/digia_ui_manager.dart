import '../dui_dev_config.dart';
import '../dui_logger.dart';
import '../framework/data_type/variable.dart';
import '../network/network_client.dart';
import 'digia_ui.dart';

class DigiaUIManager {
  static final DigiaUIManager _instance = DigiaUIManager._();

  factory DigiaUIManager() => _instance;

  DigiaUIManager._();

  DigiaUI? _digiaUI;

  void initialize(DigiaUI digiaUI) async {
    _digiaUI = digiaUI;
  }

  void destroy() {
    _digiaUI = null;
  }

  DigiaUI? get safeInstance => _digiaUI;

  String get accessKey => _digiaUI!.initConfig.accessKey;
  DUILogger? get logger => _digiaUI!.initConfig.developerConfig.logger;
  Map<String, Variable> get environmentVariables =>
      _digiaUI!.dslConfig.getEnvironmentVariables();
  DigiaUIHost? get host => _digiaUI!.initConfig.developerConfig.host;
  NetworkClient get networkClient => _digiaUI!.networkClient;
}
