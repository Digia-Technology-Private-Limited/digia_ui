import 'dart:convert';

import '../../Utils/download_operations.dart';
import '../../Utils/file_operations.dart';
import '../../framework/utils/types.dart';
import '../exception.dart';
import '../model.dart';
import '../provider.dart';
import 'base.dart';

class NetworkFileConfigSource implements ConfigSource {
  final ConfigProvider provider;
  final String networkPath;
  final String cacheFilePath;
  final Duration? timeout;
  final FileOperations fileOps;
  final DownloadOperations downloadOps = DownloadOperationsImpl();

  NetworkFileConfigSource(
    this.provider,
    this.networkPath, {
    this.cacheFilePath = 'appConfig.json',
    this.timeout,
    this.fileOps = const FileOperationsImpl(),
  });

  @override
  Future<DUIConfig> getConfig() async {
    // 1. Get file metadata from network
    final metadata = await _getConfigMetadata();
    if (!_shouldDownloadNewConfig(metadata)) {
      return await _loadCachedConfig();
    }

    // 2. Download and cache the file
    final fileUrl = _getFileUrl(metadata);
    final config = await _downloadAndCacheConfig(fileUrl);

    // 3. Initialize functions
    await provider.initFunctions(
      remotePath: config.functionsFilePath,
      version: config.version,
    );

    return config;
  }

  String _getFileUrl(Map<String, dynamic> metadata) {
    final fileUrl = metadata['appConfigFileUrl'] as String?;
    if (fileUrl == null) {
      throw ConfigException('Config File URL not found');
    }
    return fileUrl;
  }

  Future<JsonLike> _getConfigMetadata() async {
    final data = await provider.getAppConfigFromNetwork(networkPath);
    if (data == null || data.isEmpty) {
      throw ConfigException('Failed to fetch config metadata');
    }
    return data;
  }

  bool _shouldDownloadNewConfig(Map<String, dynamic> metadata) {
    return metadata['versionUpdated'] != false;
  }

  Future<DUIConfig> _loadCachedConfig() async {
    final cachedJson = await fileOps.readString(cacheFilePath);
    if (cachedJson == null) {
      throw ConfigException('No cached config found');
    }
    return DUIConfig(json.decode(cachedJson));
  }

  Future<DUIConfig> _downloadAndCacheConfig(String fileUrl) async {
    // Download file with timeout
    final file = await Future.any([
      downloadOps.downloadFile(fileUrl, cacheFilePath),
      if (timeout != null) Future.delayed(timeout!).then((_) => null),
    ]);
    if (file == null || file.data == null) {
      throw ConfigException('Failed to download config file');
    }

    // Parse and cache
    final fileString = utf8.decode(file.data);
    // await writeStringToFile(fileString, cacheFilePath);

    return DUIConfig(json.decode(fileString));
  }
}
