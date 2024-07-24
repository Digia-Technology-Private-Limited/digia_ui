import 'package:talker/talker.dart';

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  bool enableChucker;
  Talker? talker = Talker();

  DeveloperConfig({
    this.proxyUrl,
    this.enableChucker = false,
    this.talker,
  });
}
