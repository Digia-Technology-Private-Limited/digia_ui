import '../exception.dart';
import '../model.dart';
import 'base.dart';

class FallbackConfigSource implements ConfigSource {
  final ConfigSource primary;
  final List<ConfigSource> fallback;

  FallbackConfigSource({
    required this.primary,
    this.fallback = const [],
  });

  @override
  Future<DUIConfig> getConfig() async {
    try {
      return await primary.getConfig();
    } catch (e) {
      for (final source in fallback) {
        try {
          return await source.getConfig();
        } catch (_) {
          continue;
        }
      }
      throw ConfigException('All config sources failed');
    }
  }
}
