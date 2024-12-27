import 'dui_logger.dart';
import 'inspector/dui_inspector.dart';

enum DigiaUIEnvironment { dashboard, client, development }

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  DUIInspector? inspector;
  DUILogger? logger;
  final DigiaUIEnvironment? environment;

  DeveloperConfig({
    this.proxyUrl,
    this.inspector,
    this.logger,
    this.environment,
  });
}
