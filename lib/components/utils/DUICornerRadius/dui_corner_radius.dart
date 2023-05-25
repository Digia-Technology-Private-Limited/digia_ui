part 'dui_corner_radius.json.dart';

class DUICornerRadius {
  double topLeft;
  double topRight;
  double bottomRight;
  double bottomLeft;

  DUICornerRadius({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomRight = 0,
    this.bottomLeft = 0,
  });

  factory DUICornerRadius.fromJson(dynamic json) =>
      _$DUICornerRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$DUICornerRadiusToJson(this);

  @override
  String toString() {
    return "topLeft:$topLeft, topRight:$topRight, bottomRight:$bottomRight, bottomLeft:$bottomLeft";
  }
}
