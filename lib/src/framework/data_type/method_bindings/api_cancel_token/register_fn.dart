import 'package:dio/dio.dart';

import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForApiCancelToken(MethodBindingRegistry registry) {
  registry.registerMethods<CancelToken>({
    'cancel': APICancelTokenCommand(),
  });
}
