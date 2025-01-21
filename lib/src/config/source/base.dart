import '../model.dart';

abstract class ConfigSource {
  Future<DUIConfig> getConfig();
}
