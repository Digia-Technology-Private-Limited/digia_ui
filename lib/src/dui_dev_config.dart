import 'dui_logger.dart';
import 'inspector/dui_inspector.dart';

sealed class DigiaUIHost {
  final String? resourceUrl;
  const DigiaUIHost({this.resourceUrl});
}

class DashboardHost extends DigiaUIHost {
  const DashboardHost({super.resourceUrl});
}

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
