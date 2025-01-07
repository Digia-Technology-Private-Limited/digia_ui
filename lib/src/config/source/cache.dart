import 'dart:convert';

import '../../file_operations.dart';
import '../exception.dart';
import '../model.dart';
import '../provider.dart';
import 'base.dart';

class CachedConfigSource implements ConfigSource {
  final ConfigProvider provider;
  final String _cachedFilePath;
  final FileOperations fileOps;

  const CachedConfigSource(
    this.provider,
    this._cachedFilePath, {
    this.fileOps = const FileOperationsImpl(),
  });

  @override
  Future<DUIConfig> getConfig() async {
    final cachedJson = await fileOps.readString(_cachedFilePath);
    if (cachedJson == null) throw ConfigException('No cached config found');

    final config = DUIConfig(json.decode(cachedJson));
    await provider.initFunctions(
      remotePath: config.functionsFilePath,
      version: config.version,
    );
    return config;
  }
}
