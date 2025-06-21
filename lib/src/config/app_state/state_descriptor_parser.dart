import 'dart:convert';

import '../../framework/utils/object_util.dart';
import '../../framework/utils/types.dart';
import 'global_state.dart';

abstract class StateDescriptorParser<T> {
  StateDescriptor<T> parse(JsonLike json);
}

class StateDescriptorFactory {
  final Map<String, StateDescriptorParser> _parsers = {
    'number': NumDescriptorParser(),
    'string': StringDescriptorParser(),
    'bool': BoolDescriptorParser(),
    'json': JsonDescriptorParser(),
    'list': JsonArrayDescriptorParser(),
  };

  final Map<String, String> _typeAliases = {
    'boolean': 'bool',
    'numeric': 'number',
    'array': 'list',
  };

  StateDescriptor<dynamic> fromJson(JsonLike json) {
    final type = json['type'];
    final parser = _parsers[type] ?? _parsers[_typeAliases[type]];
    if (parser == null) {
      throw UnsupportedError('Unknown state type: $type');
    }
    return parser.parse(json);
  }
}

class NumDescriptorParser implements StateDescriptorParser<num> {
  @override
  StateDescriptor<num> parse(JsonLike json) {
    return StateDescriptor<num>(
      key: json['name'] as String,
      initialValue: json['value'] is num
          ? json['value'] as num
          : json['value']?.to<num>() ?? 0,
      shouldPersist: (json['shouldPersist'].to<bool>()) ?? false,
      deserialize: (s) => s.to<num>() ?? 0,
      serialize: (v) => v.toString(),
      description: 'number',
      streamName: json['streamName'] as String,
    );
  }
}

class StringDescriptorParser implements StateDescriptorParser<String> {
  @override
  StateDescriptor<String> parse(JsonLike json) {
    return StateDescriptor<String>(
      key: json['name'] as String,
      initialValue: json['value']?.toString() ?? '',
      shouldPersist: (json['shouldPersist'].to<bool>()) ?? false,
      deserialize: (s) => s,
      serialize: (v) => v,
      description: 'string',
      streamName: json['streamName'] as String,
    );
  }
}

class BoolDescriptorParser implements StateDescriptorParser<bool> {
  @override
  StateDescriptor<bool> parse(JsonLike json) {
    bool parseBool(Object? value) {
      if (value is num) return value != 0;
      return value?.to<bool>() ?? false;
    }

    return StateDescriptor<bool>(
      key: json['name'] as String,
      initialValue: parseBool(json['value']),
      shouldPersist: (json['shouldPersist'].to<bool>()) ?? false,
      deserialize: (s) => s.to<bool>() ?? false,
      serialize: (v) => v.toString(),
      description: 'bool',
      streamName: json['streamName'] as String,
    );
  }
}

class JsonDescriptorParser implements StateDescriptorParser<JsonLike> {
  @override
  StateDescriptor<JsonLike> parse(JsonLike json) {
    JsonLike parseJson(Object? value) {
      return value.to<JsonLike>() ?? {};
    }

    return StateDescriptor<JsonLike>(
      key: json['name'] as String,
      initialValue: parseJson(json['value']),
      shouldPersist: (json['shouldPersist'].to<bool>()) ?? false,
      deserialize: (s) => parseJson(s),
      serialize: (v) => jsonEncode(v),
      description: 'json',
      streamName: json['streamName'] as String,
    );
  }
}

class JsonArrayDescriptorParser implements StateDescriptorParser<List> {
  @override
  StateDescriptor<List> parse(JsonLike json) {
    List parseList(Object? value) {
      return value.to<List>() ?? [];
    }

    return StateDescriptor<List>(
      key: json['name'] as String,
      initialValue: parseList(json['value']),
      shouldPersist: (json['shouldPersist'].to<bool>()) ?? false,
      deserialize: (s) => parseList(s),
      serialize: (v) => jsonEncode(v),
      description: 'list',
      streamName: json['streamName'] as String,
    );
  }
}
