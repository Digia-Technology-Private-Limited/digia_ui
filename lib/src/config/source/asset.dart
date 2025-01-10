import 'dart:convert';

import '../../framework/utils/functional_util.dart';
import '../../framework/utils/json_util.dart';
import '../../framework/utils/types.dart';
import '../model.dart';
import '../provider.dart';
import 'base.dart';

class AssetConfigSource implements ConfigSource {
  final ConfigProvider provider;
  final String _appConfigPath;
  final String _functionsPath;

  AssetConfigSource(
    this.provider,
    this._appConfigPath,
    this._functionsPath,
  );

  @override
  Future<DUIConfig> getConfig() async {
    final burnedJson = await provider.bundleOps.readString(_appConfigPath);
    final config = DUIConfig(
        as<JsonLike>(json.decode(burnedJson)).valueFor('data.response'));

    await provider.initFunctions(localPath: _functionsPath);
    return config;
  }
}
