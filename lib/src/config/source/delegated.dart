import '../exception.dart';
import '../model.dart';
import 'base.dart';

class DelegatedConfigSource implements ConfigSource {
  final Future<DUIConfig> Function() getConfigFn;

  DelegatedConfigSource(
    this.getConfigFn,
  );

  @override
  Future<DUIConfig> getConfig() async {
    try {
      return getConfigFn();
    } catch (e, stackTrace) {
      throw ConfigException(
        'Failed to execute config function',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
