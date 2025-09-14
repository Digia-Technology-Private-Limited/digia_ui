import 'package:digia_expr/digia_expr.dart';
import 'package:digia_inspector_core/digia_inspector_core.dart';

import '../dui_dev_config.dart';

import '../framework/data_type/variable.dart';
import '../network/network_client.dart';
import 'digia_ui.dart';

class DigiaUIManager {
  static final DigiaUIManager _instance = DigiaUIManager._();

  factory DigiaUIManager() => _instance;

  DigiaUIManager._();

  DigiaUI? _digiaUI;

  void initialize(DigiaUI digiaUI) {
    _digiaUI = digiaUI;
  }

  void destroy() {
    _digiaUI = null;
  }

  DigiaUI? get safeInstance => _digiaUI;

  String get accessKey => _digiaUI!.initConfig.accessKey;
  DigiaInspector? get inspector =>
      _digiaUI?.initConfig.developerConfig.inspector;
  Map<String, Variable> get environmentVariables =>
      _digiaUI!.dslConfig.getEnvironmentVariables();
  DigiaUIHost? get host => _digiaUI!.initConfig.developerConfig.host;
  NetworkClient get networkClient => _digiaUI!.networkClient;

  Map<String, Object?> get jsVars => {
        'js': ExprClassInstance(
            klass: ExprClass(name: 'js', fields: {}, methods: {
          'eval': ExprCallableImpl(
              fn: (evaluator, arguments) {
                return safeInstance?.dslConfig.jsFunctions?.callJs(
                    _toValue<String>(evaluator, arguments[0])!,
                    arguments
                        .skip(1)
                        .map((e) => _toValue(evaluator, e))
                        .toList());
              },
              arity: 2)
        }))
      };

  // ignore: strict_top_level_inference
  T? _toValue<T>(evaluator, Object obj) {
    if (obj is ASTNode) {
      final result = evaluator.eval(obj);
      return result as T?;
    }

    return obj as T?;
  }
}
