import '../../digia_ui.dart';
import '../framework/data_type/variable.dart';
import '../framework/data_type/variable_json_converter.dart';
import '../framework/utils/functional_util.dart';
import '../network/api_request/api_request.dart';

class DUIConfig {
  final Map<String, dynamic> _themeConfig;
  final Map<String, Object?> pages;
  final Map<String, Object?>? components;
  final Map<String, dynamic> restConfig;
  final String initialRoute;
  final String? functionsFilePath;
  final List? appState;
  final bool? versionUpdated;
  final int? version;
  final Map<String, dynamic>? _environment;

  DUIConfig(dynamic data)
      : _themeConfig = as<Map<String, dynamic>>(data['theme']),
        pages = as<Map<String, Object?>>(data['pages']),
        components = as$<Map<String, Object?>>(data['components']),
        restConfig = as<Map<String, dynamic>>(data['rest']),
        initialRoute = as<String>(data['appSettings']['initialRoute']),
        appState = as$<List>(data['appState']),
        version = as$<int>(data['version']),
        versionUpdated = as$<bool>(data['versionUpdated']),
        functionsFilePath = as$<String>(data['functionsFilePath']),
        _environment = as$<Map<String, dynamic>>(data['environment']);

  Map<String, dynamic> get _colors =>
      as<Map<String, dynamic>>(_themeConfig['colors']['light']);

  Map<String, Object?> get colorTokens =>
      as<Map<String, Object?>>(_themeConfig['colors']['light']);

  Map<String, Object?> get darkColorTokens =>
      as<Map<String, Object?>>(_themeConfig['colors']['dark']);
  Map<String, Object?> get fontTokens =>
      as<Map<String, Object?>>(_themeConfig['fonts']);

  void setEnvVariable(String varName, Object? value) {
    final Map<String, Variable> variables =
        DigiaUIClient.instance.config.getEnvironmentVariables();
    if (!variables.containsKey(varName)) {
      return;
    }
    variables[varName] = variables[varName]!.copyWith(defaultValue: value);

    _environment?['variables'] =
        const VariableJsonConverter().toJson(variables);
  }

  String? getColorValue(String colorToken) {
    return as$<String>(_colors[colorToken]);
  }

  Map<String, dynamic>? getDefaultHeaders() {
    return as$<Map<String, dynamic>>(restConfig['defaultHeaders']);
  }

  Map<String, Variable> getEnvironmentVariables() {
    return const VariableJsonConverter()
        .fromJson(as$<Map<String, dynamic>>(_environment?['variables']));
  }

  APIModel getApiDataSource(String id) {
    return APIModel.fromJson(
        as<Map<String, dynamic>>(restConfig['resources'][id]));
  }
}
