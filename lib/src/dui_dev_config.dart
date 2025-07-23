import 'dui_logger.dart';
import 'inspector/dui_inspector.dart';

sealed class DigiaUIHost {
  final String? resourceProxyUrl;
  const DigiaUIHost({this.resourceProxyUrl});
}

class DashboardHost extends DigiaUIHost {
  const DashboardHost({super.resourceProxyUrl});
}

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  final DUIInspector? inspector;
  final DUILogger? logger;
  final DigiaUIHost? host;
  final String baseUrl;

  const DeveloperConfig({
    this.proxyUrl,
    this.inspector,
    this.logger,
    this.host,
    this.baseUrl = 'https://app.digia.tech/api/v1',
  });
}
