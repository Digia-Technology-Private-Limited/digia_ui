import '../utils/functional_util.dart';

class VWRepeatData {
  final String type;
  final Object? datum;

  bool get isJson => type == 'json';

  VWRepeatData({required this.type, required this.datum});

  static VWRepeatData? fromJson(Object? json) {
    if (json == null) return null;

    if (json is String) {
      return VWRepeatData(type: 'json', datum: json);
    }

    if (json is Map) {
      if (json['expr'] != null) {
        return VWRepeatData(type: 'object_path', datum: json['expr']);
      }

      // Fallback for legacy format
      if (json['kind'] != null && json['datum'] != null) {
        return VWRepeatData(
            type: as<String>(json['kind']), datum: json['datum']);
      }
    }

    return null;
  }
}
