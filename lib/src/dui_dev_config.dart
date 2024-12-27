import 'dui_logger.dart';
import 'inspector/dui_inspector.dart';

enum DigiaUIHost { dashboard, client, development }

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  DUIInspector? inspector;
  DUILogger? logger;
  final DigiaUIHost? host;

  DeveloperConfig({
    this.proxyUrl,
    this.inspector,
    this.logger,
    this.host,
  });
}
