import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'text_props.dart';

class SliverAppBarProps {
  final TextProps title;
  final ExprOr<double>? elevation;
  final ExprOr<String>? shadowColor;
  final ExprOr<String>? backgroundColor;
  final ExprOr<String>? iconColor;
  final JsonLike? leadingIcon;
  final ExprOr<bool>? automaticallyImplyLeading;
  final ExprOr<String>? defaultButtonColor;
  final ActionFlow? onTapLeadingIcon;
  final JsonLike? trailingIcon;
  final ExprOr<bool>? centerTitle;
  final ExprOr<bool>? useTitleWidget;
  final ExprOr<double>? titleSpacing;
  final ExprOr<bool>? collapsibleAppBar;
  final ExprOr<String>? expandedHeight;
  final ExprOr<String>? collapsedHeight;
  final ExprOr<bool>? pinned;
  final ExprOr<bool>? floating;
  final ExprOr<bool>? snap;
  final ExprOr<String>? height;
  final ExprOr<String>? toolbarHeight;
  final ExprOr<bool>? useBottomWidget;
  final ExprOr<String>? bottomSectionHeight;
  final ExprOr<String>? bottomSectionWidth;
  final ExprOr<bool>? useFlexibleSpace;
  final ExprOr<String>? titlePadding;
  final ExprOr<bool>? useBackgroundWidget;
  final JsonLike? backgroundImage;
  final JsonLike? shape;
  final ExprOr<bool>? useLeadingWidget;
  final ExprOr<bool>? useActionsWidget;

  const SliverAppBarProps({
    required this.title,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.iconColor,
    this.leadingIcon,
    this.onTapLeadingIcon,
    this.trailingIcon,
    this.centerTitle,
    this.titleSpacing,
    this.collapsibleAppBar,
    this.expandedHeight,
    this.collapsedHeight,
    this.pinned,
    this.floating,
    this.snap,
    this.toolbarHeight,
    this.useFlexibleSpace,
    this.titlePadding,
    this.useBackgroundWidget,
    this.backgroundImage,
    this.shape,
    this.useLeadingWidget,
    this.useActionsWidget,
    this.useBottomWidget,
    this.bottomSectionHeight,
    this.bottomSectionWidth,
    this.automaticallyImplyLeading,
    this.defaultButtonColor,
    this.useTitleWidget,
    this.height,
  });

  factory SliverAppBarProps.fromJson(JsonLike json) {
    return SliverAppBarProps(
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
      trailingIcon: as$<JsonLike>(json['trailingIcon']),
      centerTitle: ExprOr.fromJson<bool>(json['centerTitle']),
      titleSpacing: ExprOr.fromJson<double>(json['titleSpacing']),
      collapsibleAppBar: ExprOr.fromJson<bool>(json['collapsibleAppBar']),
      expandedHeight: ExprOr.fromJson<String>(json['expandedHeight']),
      collapsedHeight: ExprOr.fromJson<String>(json['collapsedHeight']),
      pinned: ExprOr.fromJson<bool>(json['pinned']),
      floating: ExprOr.fromJson<bool>(json['floating']),
      snap: ExprOr.fromJson<bool>(json['snap']),
      toolbarHeight: ExprOr.fromJson<String>(json['toolbarHeight']),
      useFlexibleSpace: ExprOr.fromJson<bool>(json['useFlexibleSpace']),
      titlePadding: ExprOr.fromJson<String>(json['titlePadding']),
      useBackgroundWidget: ExprOr.fromJson<bool>(json['useBackgroundWidget']),
      backgroundImage: as$<JsonLike>(json['backgroundImage']),
      shape: as$<JsonLike>(json['shape']),
      useLeadingWidget: ExprOr.fromJson<bool>(json['useLeadingWidget']),
      useActionsWidget: ExprOr.fromJson<bool>(json['useActionsWidget']),
      useBottomWidget: ExprOr.fromJson<bool>(json['useBottomWidget']),
      bottomSectionHeight: ExprOr.fromJson<String>(json['bottomSectionHeight']),
      bottomSectionWidth: ExprOr.fromJson<String>(json['bottomSectionWidth']),
      automaticallyImplyLeading:
          ExprOr.fromJson<bool>(json['automaticallyImplyLeading']),
      defaultButtonColor: ExprOr.fromJson<String>(json['defaultButtonColor']),
      useTitleWidget: ExprOr.fromJson<bool>(json['useTitleWidget']),
      height: ExprOr.fromJson<String>(json['height']),
    );
  }
}
