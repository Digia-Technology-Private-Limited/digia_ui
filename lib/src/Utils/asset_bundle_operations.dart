import 'package:flutter/services.dart';

abstract class AssetBundleOperations {
  Future<String> readString(String key);
}

class AssetBundleOperationsImpl implements AssetBundleOperations {
  const AssetBundleOperationsImpl();

  @override
  Future<String> readString(String key) {
    return rootBundle.loadString(key);
  }
}
