import 'package:dio/dio.dart';

import '../../core/action/api_handler.dart';
import '../../network/api_request/api_request.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/types.dart';
import 'types.dart';

typedef ResponseObject = JsonLike;

Future<Response<Object?>> executeApiAction(
  ScopeContext? scopeContext,
  APIModel apiModel,
  Map<String, ExprOr<Object>?>? args, {
  ExprOr<bool>? successCondition,
  Future<void> Function(JsonLike response)? onSuccess,
  Future<void> Function(JsonLike response)? onError,
}) async {
  final evaluatedArgs = apiModel.variables?.map((k, v) => MapEntry(
        k,
        args?[k]?.evaluate(scopeContext) ?? v.defaultValue,
      ));

  try {
    final response = await ApiHandler.instance
        .execute(apiModel: apiModel, args: evaluatedArgs);

    final respObj = {
      'body': response.data,
      'statusCode': response.statusCode,
      'headers': response.headers.map,
      'requestObj': _requestObjToMap(response.requestOptions),
      'error': null,
    };

    final isSuccess = successCondition?.evaluate(DefaultScopeContext(
          variables: {'response': respObj},
          enclosing: scopeContext,
        )) ??
        true;
    if (isSuccess) {
      await onSuccess?.call(respObj);
    } else {
      await onError?.call(respObj);
    }
    return response;
  } catch (error) {
    if (error is DioException) {
      final respObj = {
        'body': error.response?.data,
        'statusCode': error.response?.statusCode,
        'headers': error.response?.headers.map,
        'requestObj': _requestObjToMap(error.requestOptions),
        'error': error.message,
      };
      await onError?.call(respObj);
    }
    rethrow;
  }
}

JsonLike _requestObjToMap(RequestOptions request) {
  return {
    'url': request.path,
    'method': request.method,
    'headers': request.headers,
    'data': request.data,
    'queryParameters': request.queryParameters,
  };
}

bool hasExtension(String src, List<String> exts) {
  final uri = Uri.tryParse(src);
  final path =
      (uri?.path ?? src).toLowerCase().split('?').first.split('#').first;
  if (exts.any((e) => path.endsWith(e))) return true;
  if (src.startsWith('data:')) {
    final lower = src.toLowerCase();
    if (exts.contains('.svg') && lower.startsWith('data:image/svg+xml')) {
      return true;
    }
  }
  return false;
}
