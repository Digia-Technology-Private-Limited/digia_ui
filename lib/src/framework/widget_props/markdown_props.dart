import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class MarkDownProps {
  final ExprOr<String>? data;
  final ExprOr<int>? duration;
  final bool? shrinkWrap;
  final bool? selectable;
  final ExprOr<bool>? animationEnabled;
  final ActionFlow? onLinkTap;
  final ExprOr<double>? hrHeight;
  final ExprOr<String>? hrColor;
  final JsonLike? h1TextStyle;
  final JsonLike? h2TextStyle;
  final JsonLike? h3TextStyle;
  final JsonLike? h4TextStyle;
  final JsonLike? h5TextStyle;
  final JsonLike? h6TextStyle;
  final JsonLike? codeTextStyle;
  final JsonLike? pTextStyle;
  final JsonLike? linkTextStyle;
  final ExprOr<double>? listMarginLeft;
  final ExprOr<double>? listMarginBottom;
  final ExprOr<String>? blockSideColor;
  final ExprOr<String>? blockTextColor;
  final ExprOr<double>? blockSideWidth;
  final Object? blockPadding;
  final Object? blockMargin;
  final Object? prePadding;
  final Object? preMargin;
  final ExprOr<String>? preColor;
  final Object? preBorderRadius;
  final JsonLike? preTextStyle;
  final ExprOr<String>? preLanguage;
  // final JsonLike? tableHeaderTextStyle;
  // final JsonLike? tableBodyTextStyle;
  // final Object? tableHeaderPadding;
  // final Object? tableBodyPadding;

  MarkDownProps({
    // this.tableHeaderTextStyle,
    // this.tableBodyTextStyle,
    // this.tableHeaderPadding,
    // this.tableBodyPadding,
    this.animationEnabled,
    this.shrinkWrap,
    this.selectable,
    this.duration,
    this.hrHeight,
    this.hrColor,
    this.h1TextStyle,
    this.h2TextStyle,
    this.h3TextStyle,
    this.h4TextStyle,
    this.h5TextStyle,
    this.h6TextStyle,
    this.codeTextStyle,
    this.pTextStyle,
    this.linkTextStyle,
    this.listMarginLeft,
    this.listMarginBottom,
    this.blockSideColor,
    this.blockTextColor,
    this.blockSideWidth,
    this.blockPadding,
    this.blockMargin,
    this.prePadding,
    this.preMargin,
    this.preColor,
    this.preBorderRadius,
    this.preTextStyle,
    this.preLanguage,
    this.data,
    // this.textStyle,
    // this.maxLines,
    // this.alignment,
    // this.overflow,
    this.onLinkTap,
  });

  factory MarkDownProps.fromJson(JsonLike json) {
    final hrConfig = json['horizontalRules'] as JsonLike?;
    final h1Config = json['heading1'] as JsonLike?;
    final h2Config = json['heading2'] as JsonLike?;
    final h3Config = json['heading3'] as JsonLike?;
    final h4Config = json['heading4'] as JsonLike?;
    final h5Config = json['heading5'] as JsonLike?;
    final h6Config = json['heading6'] as JsonLike?;
    final preConfig = json['codeBlock'] as JsonLike?;
    final linkConfig = json['link'] as JsonLike?;
    final pConfig = json['paragraph'] as JsonLike?;
    final blockQuoteConfig = json['blockQuote'] as JsonLike?;
    final listConfig = json['list'] as JsonLike?;
    final codeConfig = json['code'] as JsonLike?;
    final tableConfig = json['table'] as JsonLike?;

    return MarkDownProps(
      duration: ExprOr.fromJson<int>(json['duration']),
      data: ExprOr.fromJson<String>(json['data']),
      animationEnabled: ExprOr.fromJson<bool>(json['animationEnabled']),
      shrinkWrap: as$<bool>(json['shrinkWrap']),
      selectable: as$<bool>(json['selectable']),
      //hrConfig
      hrColor: ExprOr.fromJson<String>(hrConfig?['color']),
      hrHeight: ExprOr.fromJson<double>(hrConfig?['height']),
      //h1config
      h1TextStyle: as$<JsonLike>(h1Config?['textStyle']),
      //h2config
      h2TextStyle: as$<JsonLike>(h2Config?['textStyle']),
      //h3config
      h3TextStyle: as$<JsonLike>(h3Config?['textStyle']),
      //h4config
      h4TextStyle: as$<JsonLike>(h4Config?['textStyle']),
      //h5config
      h5TextStyle: as$<JsonLike>(h5Config?['textStyle']),
      //h6config
      h6TextStyle: as$<JsonLike>(h6Config?['textStyle']),
      //preConfig
      prePadding: preConfig?['padding'],
      preMargin: preConfig?['margin'],
      preColor: ExprOr.fromJson<String>(preConfig?['color']),
      preBorderRadius: preConfig?['borderRadius'],
      preTextStyle: as$<JsonLike>(preConfig?['textStyle']),
      preLanguage: ExprOr.fromJson<String>(preConfig?['language']),
      //linkConfig
      onLinkTap: ActionFlow.fromJson(linkConfig?['onLinkTap']),
      linkTextStyle: as$<JsonLike>(linkConfig?['textStyle']),
      //pConfig
      pTextStyle: as$<JsonLike>(pConfig?['textStyle']),
      //block quote config
      blockSideColor: ExprOr.fromJson<String>(blockQuoteConfig?['sideColor']),
      blockTextColor: ExprOr.fromJson<String>(blockQuoteConfig?['textColor']),
      blockSideWidth: ExprOr.fromJson<double>(blockQuoteConfig?['sideWidth']),
      blockPadding: blockQuoteConfig?['padding'],
      blockMargin: blockQuoteConfig?['margin'],
      //list Config
      listMarginLeft: ExprOr.fromJson<double>(listConfig?['marginLeft']),
      listMarginBottom: ExprOr.fromJson<double>(listConfig?['marginBottom']),
      //code config
      codeTextStyle: as$<JsonLike>(codeConfig?['textStyle']),
      //tableConfig
      // tableBodyTextStyle: as$<JsonLike>(tableConfig?['bodyTextStyle']),
      // tableHeaderTextStyle: as$<JsonLike>(tableConfig?['headerTextStyle']),
      // tableBodyPadding: tableConfig?['bodyPadding'],
      // tableHeaderPadding: tableConfig?['headerPadding'],
    );
  }
}
