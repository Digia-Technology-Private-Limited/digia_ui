import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'text_props.dart';

class AppBarProps {
  final TextProps title;
  final ExprOr<double>? elevation;
  final ExprOr<String>? shadowColor;
  final ExprOr<String>? backgroundColor;
  final ExprOr<String>? iconColor;
  final JsonLike? leadingIcon;
  final ActionFlow? onTapLeadingIcon;
  final JsonLike? trailingIcon;

  const AppBarProps({
    required this.title,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.iconColor,
    this.leadingIcon,
    this.onTapLeadingIcon,
    this.trailingIcon,
  });

  factory AppBarProps.fromJson(JsonLike json) {
    return AppBarProps(
      title:
          as$<JsonLike>(json['title']).maybe(TextProps.fromJson) ?? TextProps(),
      elevation: ExprOr.fromJson<double>(json['elevation']),
      shadowColor: ExprOr.fromJson<String>(json['shadowColor']),
      backgroundColor: tryKeys<ExprOr<String>>(
        json,
        ['backgrounColor', 'backgroundColor'],
        parse: (p0) => ExprOr.fromJson<String>(p0),
      ),
      iconColor: ExprOr.fromJson<String>(json['iconColor']),
      leadingIcon: as$<JsonLike>(json['leadingIcon']),
      onTapLeadingIcon: ActionFlow.fromJson(json['onTapLeadingIcon']),
      trailingIcon: as$<JsonLike>(json['leadingIcon']),
    );
  }
}
