part 'dui_insets.json.dart';

class DUIInsets {
  String top;
  String bottom;
  String left;
  String right;

  DUIInsets(
      {this.top = '0', this.bottom = '0', this.left = '0', this.right = '0'});

  factory DUIInsets.fromJson(dynamic json) => _$DUIInsetsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIInsetsToJson(this);
}
