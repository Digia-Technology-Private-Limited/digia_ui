import 'dart:convert';

typedef JsonReviver = Object? Function(Object? key, Object? value);

/// Attempts to decode a JSON string, returning null if decoding fails.
///
/// This function provides a safe way to decode JSON without throwing exceptions.
///
/// [source] The JSON string to decode.
/// [reviver] An optional function that can be used to transform the decoded values.
///
/// Returns the decoded JSON object, or null if decoding fails.
Object? tryJsonDecode(String source, {JsonReviver? reviver}) {
  try {
    return jsonDecode(source, reviver: reviver);
  } catch (e) {
    // Consider using a logging framework instead of print for production code
    print('JSON decode error: $e');
    return null;
  }
}

/// Attempts to retrieve a value from a JSON object using multiple possible keys.
///
/// [json] The JSON object to search in.
/// [keys] An ordered list of keys to try.
/// [parse] Optional function to cast or transform the value if found.
///
/// Returns the value associated with the first matching key, or null if no key is found.
T? tryKeys<T>(
  Map<String, dynamic> json,
  List<String> keys, {
  T? Function(dynamic)? parse,
}) {
  for (final key in keys) {
    if (json.containsKey(key)) {
      final value = json[key];
      return parse != null ? parse(value) : value as T?;
    }
  }
  return null;
}
