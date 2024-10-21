import '../utils/functional_util.dart';

class VWRepeatData {
  final String type;
  final Object? datum;

  bool get isJson => type == 'json';

  VWRepeatData({required this.type, required this.datum});

  static VWRepeatData? fromJson(Object? json) {
    if (json is! Map) return null;

    if (json['kind'] == null || json['datum'] == null) return null;

    return VWRepeatData(type: as<String>(json['kind']), datum: json['datum']);
  }
}
