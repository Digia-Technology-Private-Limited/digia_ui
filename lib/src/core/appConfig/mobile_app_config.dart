// import 'dart:convert';

// import '../../../digia_ui.dart';
// import '../../Utils/download_operations.dart';
// import '../../Utils/file_operations.dart';
// import '../../network/core/types.dart';
// import 'app_config.dart';

// class MobileAppConfig implements AppConfig {
//   final FileOperations fileOps = const FileOperationsImpl();
//   final FileDownloader downloadOps = FileDownloaderImpl();

//   @override
//   Future<Map<String, dynamic>?> getAppConfigFromNetwork(String path) async {
//     var resp = await DigiaUIClient.instance.networkClient.requestInternal(
//       HttpMethod.post,
//       path,
//       (json) => json as dynamic,
//     );
//     final data = resp.data['response'] as Map<String, dynamic>?;
//     return data;
//   }

//   @override
//   Future<Map<String, dynamic>?> getAppConfigFileFromNetwork(String path) async {
//     try {
//       final data = await getAppConfigFromNetwork(path);
//       if (data != null && data.isNotEmpty && data['versionUpdated'] != false) {
//         var file = await downloadOps.downloadFile(
//             data['appConfigFileUrl'], 'appConfig.json');

//         String fileString = utf8.decode(file?.data);
//         await fileOps.writeStringToFile(fileString, 'appConfig.json');
//         return jsonDecode(fileString);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// MobileAppConfig getAppConfig() => MobileAppConfig();
