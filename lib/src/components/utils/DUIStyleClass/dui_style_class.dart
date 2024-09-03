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
  String? height;
  String? width;
  String? clipBehavior;

  DUIStyleClass(
      {this.padding,
      this.margin,
      this.bgColor,
      this.border,
      this.height,
      this.width,
      this.clipBehavior});

  static DUIStyleClass? fromJson(dynamic json) => _$DUIStyleClassFromJson(json);

  DUIStyleClass copyWith({
    DUIInsets? padding,
    DUIInsets? margin,
    String? bgColor,
    DUIBorder? border,
    String? alignment,
    String? height,
    String? width,
    String? clipBehavior,
  }) {
    return DUIStyleClass(
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        bgColor: bgColor ?? this.bgColor,
        border: border ?? this.border,
        height: height ?? this.height,
        width: width ?? this.width,
        clipBehavior: clipBehavior ?? this.clipBehavior);
  }
}
