import 'package:talker_flutter/talker_flutter.dart';

// class DeveloperConfig {
//   //for android/ios
//   final String? proxyUrl;
//   bool enableTalker;
//   Talker? talker;

//   DeveloperConfig({
//     this.proxyUrl,
//     this.enableTalker = false,
//     this.talker,
//   });
// }

class DeveloperConfig {
  static final DeveloperConfig _instance = DeveloperConfig._internal();

  factory DeveloperConfig() => _instance;

  DeveloperConfig._internal({
    this.proxyUrl,
    this.enableTalker = false,
    this.talker,
  });

  String? proxyUrl;
  bool enableTalker;
  Talker? talker;

  static DeveloperConfig get instance => _instance;

  static void initialize({
    String? proxyUrl,
    bool enableTalker = false,
    Talker? talker,
  }) {
    _instance.proxyUrl = proxyUrl;
    _instance.enableTalker = enableTalker;
    _instance.talker = talker;
  }
}
