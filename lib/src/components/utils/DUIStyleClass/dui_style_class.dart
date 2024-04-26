import '../../../Utils/util_functions.dart';
import '../DUIBorder/dui_border.dart';
import '../DUIInsets/dui_insets.dart';

part 'dui_style_class.json.dart';

// TODO: This does not work well with state.
// Should we create a new DUIStyleClass for every state. Example Button:
// disabled -> disabledDuiStyleClass
// enabled -> duiStyleClass
class DUIStyleClass {
  DUIInsets? padding;
  DUIInsets? margin;
  String? bgColor;
  DUIBorder? border;
  String? alignment;
  String? height;
  String? width;

  DUIStyleClass(
      {this.padding,
      this.margin,
      this.bgColor,
      this.border,
      this.alignment,
      this.height,
      this.width});

  static DUIStyleClass? fromJson(dynamic json) => _$DUIStyleClassFromJson(json);

  DUIStyleClass copyWith({
    DUIInsets? padding,
    DUIInsets? margin,
    String? bgColor,
    DUIBorder? border,
    String? alignment,
    String? height,
    String? width,
  }) {
    return DUIStyleClass(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      bgColor: bgColor ?? this.bgColor,
      border: border ?? this.border,
      alignment: alignment ?? this.alignment,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }
}
