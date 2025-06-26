import '../actions/base/action_flow.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'types.dart';

class CommonStyle {
  Object? padding;
  Object? margin;
  ExprOr<String>? bgColor;
  JsonLike? border;
  Object? borderRadius;
  String? height;
  String? width;
  String? clipBehavior;

  CommonStyle({
    this.padding,
    this.margin,
    this.bgColor,
    this.border,
    this.height,
    this.width,
    this.clipBehavior,
    this.borderRadius,
  });

  factory CommonStyle.fromJson(JsonLike json) {
    return CommonStyle(
      padding: json['padding'],
      margin: json['margin'],
      bgColor: tryKeys<ExprOr<String>>(
        json,
        ['bgColor', 'backgroundColor'],
        parse: (v) => ExprOr.fromJson<String>(v),
      ),
      borderRadius: tryKeys(
        json,
        ['borderRadius', 'border.borderRadius'],
      ),
      // Backwar
      border: as$<JsonLike>(json['border']) ?? json,
      height: as$<String>(json['height']),
      width: as$<String>(json['width']),
      clipBehavior: as$<String>(json['clipBehavior']),
    );
  }
}

class CommonProps {
  final ExprOr<bool>? visibility;
  final String? align;
  final CommonStyle? style;
  final ActionFlow? onClick;
  // final Props? parentProps;

  CommonProps({
    required this.visibility,
    required this.align,
    required this.style,
    required this.onClick,
    // required this.parentProps,
  });

  factory CommonProps.fromJson(JsonLike json) {
    return CommonProps(
      visibility: ExprOr.fromJson<bool>(json['visibility']),
      align: as$<String>(json['align']),
      style: tryKeys<CommonStyle>(
        json,
        ['style', 'styleClass'],
        parse: (it) => as$<JsonLike>(it).maybe(CommonStyle.fromJson),
      ),
      onClick: ActionFlow.fromJson(json['onClick']),
      // Dont change anything. Flex & Stack use this.
      // But keys are on same level as others
      // parentProps: Props(json),
    );
  }
}
