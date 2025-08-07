import 'package:digia_ui/src/config/provider.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/utils/asset_bundle_operations.dart';
import 'package:digia_ui/src/utils/download_operations.dart';
import 'package:digia_ui/src/utils/file_operations.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigProvider extends Mock implements ConfigProvider {}

class MockAssetBundleOperations extends Mock implements AssetBundleOperations {}

class MockFileOperations extends Mock implements FileOperations {}

class MockFileDownloader extends Mock implements FileDownloader {}

class MockConfigSource extends Mock implements ConfigSource {}
