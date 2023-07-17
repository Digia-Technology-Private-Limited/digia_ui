

import '../core/pref/pref_util.dart';
import 'config_resolver.dart';

class DigiaUiSDkInitializer {
  static Future<void> initialize(String assetPath) async {
    // Perform SDK initialization tasks here
    // This could include setting up configurations, initializing services, etc.
    // Load configuration
    await ConfigResolver.initialize(assetPath);
    await PrefUtil.init();

  }
}