import 'dui_logger.dart';
import 'inspector/dui_inspector.dart';

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  DUIInspector? inspector;
  DUILogger? logger;

  DeveloperConfig({this.proxyUrl, this.inspector, this.logger});
}
