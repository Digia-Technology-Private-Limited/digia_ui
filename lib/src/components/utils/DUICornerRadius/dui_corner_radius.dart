part 'dui_corner_radius.json.dart';

class DUICornerRadius {
  double _topLeft;
  double _topRight;
  double _bottomRight;
  double _bottomLeft;

  double get topLeft => _topLeft;
  double get topRight => _topRight;
  double get bottomRight => _bottomRight;
  double get bottomLeft => _bottomLeft;

  DUICornerRadius({
    double? topLeft,
    double? topRight,
    double? bottomRight,
    double? bottomLeft,
  })  : _topLeft = topLeft ?? 0.0,
        _topRight = topRight ?? 0.0,
        _bottomRight = bottomRight ?? 0.0,
        _bottomLeft = bottomLeft ?? 0.0;

  factory DUICornerRadius.fromJson(dynamic json) => _$DUICornerRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$DUICornerRadiusToJson(this);

  @override
  String toString() {
    return 'topLeft:$topLeft, topRight:$topRight, bottomRight:$bottomRight, bottomLeft:$bottomLeft';
  }
}
