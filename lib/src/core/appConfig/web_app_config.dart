import 'dart:convert';

import '../../../digia_ui.dart';
import '../../Utils/download_operations.dart';
import '../../network/core/types.dart';
import 'app_config.dart';

class WebAppConfig implements AppConfig {
  final FileDownloader downloadOps = FileDownloaderImpl();

  @override
  Future<Map<String, dynamic>?> getAppConfigFromNetwork(String path,
      {String? branchId}) async {
    var resp = await DigiaUIClient.instance.networkClient.requestInternal(
      HttpMethod.post,
      data: {'branchId': branchId},
      path,
      (json) => json as dynamic,
    );
    final data = resp.data['response'] as Map<String, dynamic>?;
    return data;
  }

  @override
  Future<Map<String, dynamic>?> getAppConfigFileFromNetwork(String path,
      {String? branchId}) async {
    try {
      final data = await getAppConfigFromNetwork(path, branchId: branchId);
      if (data != null && data.isNotEmpty && data['version'] != null) {
        var file = await downloadOps.downloadFile(
            data['appConfigFileUrl'], 'appConfig.json');

        String fileString = utf8.decode(file?.data);
        return jsonDecode(fileString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

AppConfig getAppConfig() => WebAppConfig();
