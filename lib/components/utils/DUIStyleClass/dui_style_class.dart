import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';

part 'dui_style_class.json.dart';

// TODO: This does not work well with state.
// Should we create a new DUIStyleClass for every state. Example Button:
// disabled -> disabledDuiStyleClass
// enabled -> duiStyleClass
class DUIStyleClass {
  DUIInsets? padding;
  DUIInsets? margin;
  String? bgColor;
  DUICornerRadius? cornerRadius;
  String? alignment;
  String? height;
  String? width;

  DUIStyleClass(
      {this.padding,
      this.margin,
      this.bgColor,
      this.cornerRadius,
      this.alignment,
      this.height,
      this.width});

  static DUIStyleClass? fromJson(dynamic json) => _$DUIStyleClassFromJson(json);

  DUIStyleClass copyWith({
    DUIInsets? padding,
    DUIInsets? margin,
    String? bgColor,
    DUICornerRadius? cornerRadius,
    String? alignment,
    String? height,
    String? width,
  }) {
    return DUIStyleClass(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      bgColor: bgColor ?? this.bgColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      alignment: alignment ?? this.alignment,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }
}
