import 'package:dio/dio.dart';
import '../base.dart';

class APICancelTokenCommand implements MethodCommand<CancelToken> {
  @override
  void run(CancelToken instance, Map<String, Object?> args) {
    instance.cancel('User canceled the upload');
  }
}
