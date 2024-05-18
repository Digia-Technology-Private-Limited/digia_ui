// A valid code expression is anything inside
// the mustache braces: {{ .... }}
// String codeExpressionRegex = '/{{(.*?)}}/g';
String codeExpressionRegex = r'{{(.*?)}}';

class CodeSegment {
  final String full;
  final String trimmed;

  CodeSegment({required this.full, required this.trimmed});
}

bool hasCodeSegments(String inputString) {
  return RegExp(codeExpressionRegex).hasMatch(inputString);
}

List<Map<String, String>> extractCodeSegments(String inputString) {
  final matches = RegExp(codeExpressionRegex).allMatches(inputString);

  if (matches.isEmpty) {
    return [];
  }

  return matches.map((m) {
    return {
      'full': m.group(0)!,
      'trimmed': m.group(0)!.substring(2, m.group(0)!.length - 2).trim(),
    };
  }).toList();
}

String buildDynamicString(
    String inputString, Map<String, dynamic> variableData) {
  // final List<Map<String, String>> segments = extractCodeSegments(inputString);
  final segments = extractCodeSegments(inputString);

  // if (segments == null) return inputString;

  String outValue = inputString;

  for (final segment in segments) {
    final fullValue = segment['full'];
    final trimmedValue = segment['trimmed'];

    if (trimmedValue != null && fullValue != null) {
      final replacementValue = variableData[trimmedValue] ?? '';
      // outValue = outValue.replaceFirst(fullValue, replacementValue.toString());
      outValue = outValue.replaceAll(fullValue, replacementValue.toString());
    }
  }
  return outValue;
}
