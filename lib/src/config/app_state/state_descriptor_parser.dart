import 'dart:convert';

import '../../framework/utils/types.dart';
import 'global_state.dart';

abstract class StateDescriptorParser<T> {
  StateDescriptor<T> parse(Map<String, dynamic> json);
}

class StateDescriptorFactory {
  final Map<String, StateDescriptorParser> _parsers = {
    'number': NumDescriptorParser(),
    'string': StringDescriptorParser(),
    'bool': BoolDescriptorParser(),
    'json': JsonDescriptorParser(),
    'list': JsonArrayDescriptorParser(),
  };

  StateDescriptor<dynamic> fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final parser = _parsers[type];
    if (parser == null) {
      throw UnsupportedError('Unknown state type: $type');
    }
    return parser.parse(json);
  }
}

class NumDescriptorParser implements StateDescriptorParser<num> {
  @override
  StateDescriptor<num> parse(Map<String, dynamic> json) {
    return StateDescriptor<num>(
      key: json['name'],
      initialValue: json['value'] is num
          ? json['value']
          : num.tryParse(json['value'].toString()) ?? 0,
      shouldPersist: json['shouldPersist'] ?? true,
      fromString: (s) => num.tryParse(s) ?? 0,
      serialize: (v) => v.toString(),
    );
  }
}

class StringDescriptorParser implements StateDescriptorParser<String> {
  @override
  StateDescriptor<String> parse(Map<String, dynamic> json) {
    return StateDescriptor<String>(
      key: json['name'],
      initialValue: json['value']?.toString() ?? '',
      shouldPersist: json['shouldPersist'] ?? true,
      fromString: (s) => s,
      serialize: (v) => v,
    );
  }
}

class BoolDescriptorParser implements StateDescriptorParser<bool> {
  @override
  StateDescriptor<bool> parse(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is num) return value != 0;
      return false;
    }

    return StateDescriptor<bool>(
      key: json['name'],
      initialValue: parseBool(json['value']),
      shouldPersist: json['shouldPersist'] ?? true,
      fromString: (s) => s.toLowerCase() == 'true',
      serialize: (v) => v.toString(),
    );
  }
}

class JsonDescriptorParser implements StateDescriptorParser<JsonLike?> {
  @override
  StateDescriptor<JsonLike?> parse(Map<String, dynamic> json) {
    JsonLike? parseJson(dynamic value) {
      if (value is JsonLike) return value;

      return null;
    }

    return StateDescriptor<JsonLike?>(
      key: json['name'],
      initialValue: parseJson(json['value']),
      shouldPersist: json['shouldPersist'] ?? true,
      fromString: (s) => jsonDecode(s),
      serialize: (v) => jsonEncode(v),
    );
  }
}

class JsonArrayDescriptorParser
    implements StateDescriptorParser<JsonArrayLike?> {
  @override
  StateDescriptor<JsonArrayLike?> parse(Map<String, dynamic> json) {
    JsonArrayLike? parseJson(dynamic value) {
      if (value is JsonArrayLike) return value;

      return null;
    }

    return StateDescriptor<JsonArrayLike?>(
      key: json['name'],
      initialValue: parseJson(json['value']),
      shouldPersist: json['shouldPersist'] ?? true,
      fromString: (s) => jsonDecode(s),
      serialize: (v) => jsonEncode(v),
    );
  }
}
