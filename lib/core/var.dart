import 'package:digia_ui/core/pref/pref_util.dart';

const allowedVarExpressionRegex = r'\$\{\s{0,}([\w\.-]+)\s{0,}\}';

String? extractVar(String exp) {
  final matches = RegExp(allowedVarExpressionRegex).allMatches(exp.trim());
  return matches.firstOrNull?.group(1);
}

String? getMatchedExpression(String exp) {
  final matches = RegExp(allowedVarExpressionRegex).allMatches(exp.trim());
  return matches.firstOrNull?.group(0);
}

bool isVar(String exp) {
  return RegExp(allowedVarExpressionRegex).hasMatch(exp.trim());
}

String getValueIfVar(String variable) {
  final splitValues = variable.split('.');
  switch (splitValues[0]) {
    case 'localStorage':
      final prefKey = splitValues.skip(1).join('.').trim();
      return PrefUtil.get(prefKey);
  }

  return variable;
}
