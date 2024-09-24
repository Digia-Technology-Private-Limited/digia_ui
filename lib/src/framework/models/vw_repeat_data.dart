import '../utils/json_util.dart';

class VWRepeatData {
  final String type;
  final Object? datum;

  bool get isJson => type == 'json';

  List<Object>? toJsonArray() {
    if (!isJson) return null;

    final source = datum as String?;

    if (source == null || source.isEmpty) return null;

    final decoded = tryJsonDecode(source);

    if (decoded == null || decoded is! List) return null;

    return decoded.cast<Object>();
  }

  VWRepeatData({required this.type, required this.datum});

  static VWRepeatData? fromJson(Object? json) {
    if (json is! Map) return null;

    if (json['kind'] == null || json['datum'] == null) return null;

    return VWRepeatData(type: json['kind'], datum: json['datum']);
  }
}
