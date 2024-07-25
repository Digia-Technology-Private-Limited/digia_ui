import 'package:talker_flutter/talker_flutter.dart';

class DeveloperConfig {
  //for android/ios
  final String? proxyUrl;
  bool enableTalker;
  Talker? talker;

  DeveloperConfig({
    this.proxyUrl,
    this.enableTalker = false,
    this.talker,
  });
}
