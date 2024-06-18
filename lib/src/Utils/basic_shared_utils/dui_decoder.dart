import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'lodash.dart';
import 'num_decoder.dart';

class DUIDecoder {
  static MainAxisAlignment? toMainAxisAlginment(dynamic value) {
    return switch (value) {
      'start' => MainAxisAlignment.start,
      'end' => MainAxisAlignment.end,
      'center' => MainAxisAlignment.center,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => null
    };
  }

  static MainAxisAlignment toMainAxisAlginmentOrDefault(dynamic value,
      {required MainAxisAlignment defaultValue}) {
    return toMainAxisAlginment(value) ?? defaultValue;
  }

  static MainAxisSize toMainAxisSizeOrDefault(dynamic value,
      {required MainAxisSize defaultValue}) {
    return toMainAxisSize(value) ?? defaultValue;
  }

  static CrossAxisAlignment? toCrossAxisAlignment(dynamic value) =>
      switch (value) {
        'start' => CrossAxisAlignment.start,
        'end' => CrossAxisAlignment.end,
        'center' => CrossAxisAlignment.center,
        'stretch' => CrossAxisAlignment.stretch,
        'baseline' => CrossAxisAlignment.baseline,
        _ => null
      };

  static MainAxisSize? toMainAxisSize(dynamic value) => switch (value) {
        'min' => MainAxisSize.min,
        'max' => MainAxisSize.max,
        _ => null
      };

  static CrossAxisAlignment toCrossAxisAlignmentOrDefault(dynamic value,
          {required CrossAxisAlignment defaultValue}) =>
      toCrossAxisAlignment(value) ?? defaultValue;

  static FontWeight toFontWeight(String? weight) {
    switch (weight?.toLowerCase()) {
      case 'thin':
        return FontWeight.w100;
      case 'extralight':
      case 'extra-light':
      case 'extra_light':
        return FontWeight.w200;
      case 'light':
        return FontWeight.w300;
      case 'regular':
        return FontWeight.normal;
      case 'medium':
        return FontWeight.w500;
      case 'semibold':
      case 'semi-bold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w700;
      case 'extrabold':
      case 'extra-bold':
        return FontWeight.w800;
      case 'black':
        return FontWeight.w900;
    }

    return FontWeight.normal;
  }

  static FontStyle toFontStyle(dynamic style) =>
      switch (style) { 'italic' => FontStyle.italic, _ => FontStyle.normal };

  static TextAlign toTextAlign(dynamic alignment) {
    switch (alignment) {
      case 'right':
        return TextAlign.right;
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'end':
        return TextAlign.end;
      case 'justify':
        return TextAlign.justify;
    }
    return TextAlign.start;
  }

  static TextOverflow toTextOverflow(dynamic overflow) {
    switch (overflow) {
      case 'fade':
        return TextOverflow.fade;
      case 'visible':
        return TextOverflow.visible;
      case 'clip':
        return TextOverflow.clip;
      case 'ellipsis':
        return TextOverflow.ellipsis;
    }

    return TextOverflow.clip;
  }

  static TextDecoration? toTextDecoration(dynamic textDecorationToken) {
    switch (textDecorationToken) {
      case 'underline':
        return TextDecoration.underline;
      case 'overline':
        return TextDecoration.overline;
      case 'lineThrough':
        return TextDecoration.lineThrough;
      case 'none':
        return TextDecoration.none;
      default:
        return null;
    }
  }

  static TextDecorationStyle? toTextDecorationStyle(
      dynamic textDecorationStyleToken) {
    switch (textDecorationStyleToken) {
      case 'dashed':
        return TextDecorationStyle.dashed;
      case 'dotted':
        return TextDecorationStyle.dotted;
      case 'double':
        return TextDecorationStyle.double;
      case 'solid':
        return TextDecorationStyle.solid;
      case 'wavy':
        return TextDecorationStyle.wavy;
    }

    return null;
  }

  static LaunchMode toUriLaunchMode(String? value) => switch (value) {
        'inAppWebView' || 'inApp' => LaunchMode.inAppWebView,
        'externalApplication' || 'external' => LaunchMode.externalApplication,
        'externalNonBrowserApplication' =>
          LaunchMode.externalNonBrowserApplication,
        _ => LaunchMode.platformDefault
      };

  static Alignment? toAlignment(dynamic value) {
    if (value is String) {
      return switch (value) {
        'topLeft' => Alignment.topLeft,
        'topCenter' => Alignment.topCenter,
        'topRight' => Alignment.topRight,
        'centerLeft' => Alignment.centerLeft,
        'center' => Alignment.center,
        'centerRight' => Alignment.centerRight,
        'bottomLeft' => Alignment.bottomLeft,
        'bottomCenter' => Alignment.bottomCenter,
        'bottomRight' => Alignment.bottomRight,
        _ => null
      };
    }

    if (value is Map) {
      final xNullable = NumDecoder.toDouble(value['x']);
      final yNullable = NumDecoder.toDouble(value['y']);
      return (xNullable, yNullable).let((p0, p1) => Alignment(p0, p1));
    }

    return null;
  }

  static BoxFit toBoxFit(dynamic fitValue) => switch (fitValue) {
        'fill' => BoxFit.fill,
        'contain' => BoxFit.contain,
        'cover' => BoxFit.cover,
        'fitWidth' => BoxFit.fitWidth,
        'fitHeight' => BoxFit.fitHeight,
        'scaleDown' => BoxFit.scaleDown,
        _ => BoxFit.none
      };

  static EdgeInsets toEdgeInsets(dynamic value,
      {EdgeInsets or = EdgeInsets.zero}) {
    if (value == null) return or;

    if (value is List) {
      return _toEdgeInsetsFromList(
              value.map((e) => NumDecoder.toDouble(e)).nonNulls.toList()) ??
          or;
    }

    if (value is String) {
      return _toEdgeInsetsFromList(value
              .split(',')
              .map((e) => NumDecoder.toDouble(e))
              .nonNulls
              .toList()) ??
          or;
    }

    if (value is num) {
      return _toEdgeInsetsFromList([value.toDouble()]) ?? or;
    }

    if (value is Map<String, dynamic>) {
      if (value['all'] != null) {
        return EdgeInsets.all(
            NumDecoder.toDoubleOrDefault(value['all'], defaultValue: 0));
      }

      if (value['horizontal'] != null && value['vertical'] != null) {
        return EdgeInsets.symmetric(
            horizontal: NumDecoder.toDoubleOrDefault(value['horizontal'],
                defaultValue: 0),
            vertical: NumDecoder.toDoubleOrDefault(value['vertical'],
                defaultValue: 0));
      }

      return EdgeInsets.fromLTRB(
        NumDecoder.toDoubleOrDefault(value['left'], defaultValue: 0),
        NumDecoder.toDoubleOrDefault(value['top'], defaultValue: 0),
        NumDecoder.toDoubleOrDefault(value['right'], defaultValue: 0),
        NumDecoder.toDoubleOrDefault(value['bottom'], defaultValue: 0),
      );
    }

    try {
      return toEdgeInsets(value.toJson(), or: or);
    } catch (err) {
      return or;
    }
  }

  static EdgeInsets? _toEdgeInsetsFromList(List<double> values) {
    if (values.length == 1) return EdgeInsets.all(values.first);

    if (values.length == 2) {
      return EdgeInsets.symmetric(horizontal: values[0], vertical: values[1]);
    }

    if (values.length == 4) {
      return EdgeInsets.fromLTRB(values[0], values[1], values[2], values[3]);
    }

    return null;
  }

  static ScrollPhysics? toScrollPhysics(dynamic physics) {
    if (physics is bool) {
      return physics
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics();
    }

    if (physics is String) {
      return switch (physics) {
        'always' => const AlwaysScrollableScrollPhysics(),
        'bouncing' => const BouncingScrollPhysics(),
        'clamping' => const ClampingScrollPhysics(),
        'fixedExtent' => const FixedExtentScrollPhysics(),
        'never' => const NeverScrollableScrollPhysics(),
        'page' => const PageScrollPhysics(),
        'rangeMaintaining' => const RangeMaintainingScrollPhysics(),
        _ => null
      };
    }

    return null;
  }

  static Radius toRadius(dynamic value) {
    final doubleValue = NumDecoder.toDouble(value);
    if (doubleValue != null) return Radius.circular(doubleValue);

    final doubleValueFromRadii = NumDecoder.toDouble(value['radius']);
    if (doubleValueFromRadii != null) {
      return Radius.circular(doubleValueFromRadii);
    }

    final xNullable = value['x'];
    final yNullable = value['y'];

    if (xNullable != null && yNullable != null) {
      return Radius.elliptical(
        NumDecoder.toDouble(xNullable) ?? 0.0,
        NumDecoder.toDouble(yNullable) ?? 0.0,
      );
    }

    return Radius.zero;
  }

  static BorderRadius toBorderRadius(dynamic value) {
    if (value == null) return BorderRadius.zero;

    if (value is List) {
      return _toBorderRadiusFromList(value
              .map((e) => NumDecoder.toDoubleOrDefault(e, defaultValue: 0.0))
              .toList()) ??
          BorderRadius.zero;
    }

    if (value is String) {
      return _toBorderRadiusFromList(value
              .split(',')
              .map((e) => NumDecoder.toDoubleOrDefault(e, defaultValue: 0.0))
              .toList()) ??
          BorderRadius.zero;
    }

    if (value is num) {
      return _toBorderRadiusFromList([value.toDouble()]) ?? BorderRadius.zero;
    }

    if (value is Map<String, dynamic>) {
      return BorderRadius.only(
        topLeft: toRadius(value['topLeft']),
        topRight: toRadius(value['topRight']),
        bottomRight: toRadius(value['bottomRight']),
        bottomLeft: toRadius(value['bottomLeft']),
      );
    }

    try {
      return toBorderRadius(value.toJson());
    } catch (err) {
      return BorderRadius.zero;
    }
  }

  static BorderRadius? _toBorderRadiusFromList(List<double> values) {
    if (values.length == 1) {
      return BorderRadius.circular(values.first);
    }

    if (values.length == 4) {
      return BorderRadius.only(
        topLeft: toRadius(values[0]),
        topRight: toRadius(values[1]),
        bottomRight: toRadius(values[2]),
        bottomLeft: toRadius(values[3]),
      );
    }

    return null;
  }

  static Curve? toCurve(String? curveString) {
    switch (curveString) {
      case 'easeInCubic':
        return Curves.easeInCubic;
      case 'easeInExpo':
        return Curves.easeInExpo;
      case 'easeOutBack':
        return Curves.easeOutBack;
      case 'easeInOutCirc':
        return Curves.easeInOutCirc;
      case 'easeInOutCubic':
        return Curves.easeInOutCubic;
      case 'easeInOutCubicEmphasized':
        return Curves.easeInOutCubicEmphasized;
      case 'easeInOutExpo':
        return Curves.easeInOutExpo;
      case 'easeInOutQuad':
        return Curves.easeInOutQuad;
      case 'easeInOutQuart':
        return Curves.easeInOutQuart;
      case 'easeInOutQuint':
        return Curves.easeInOutQuint;
      case 'easeInOutSine':
        return Curves.easeInOutSine;
      case 'easeInQuad':
        return Curves.easeInQuad;
      case 'easeInQuart':
        return Curves.easeInQuart;
      case 'easeInQuint':
        return Curves.easeInQuint;
      case 'easeInSine':
        return Curves.easeInSine;
      case 'easeInToLinear':
        return Curves.easeInToLinear;
      case 'easeOutCirc':
        return Curves.easeOutCirc;
      case 'easeOutCubic':
        return Curves.easeOutCubic;
      case 'easeOutExpo':
        return Curves.easeOutExpo;
      case 'easeOutQuad':
        return Curves.easeOutQuad;
      case 'easeOutQuart':
        return Curves.easeOutQuart;
      case 'easeOutQuint':
        return Curves.easeOutQuint;
      case 'easeOutSine':
        return Curves.easeOutSine;
      case 'elasticInOut':
        return Curves.elasticInOut;
      case 'elasticIn':
        return Curves.elasticIn;
      case 'elasticOut':
        return Curves.elasticOut;
      case 'fastEaselnToSlowOut':
        return Curves.fastEaseInToSlowEaseOut;
      case 'fastLinearToSlowEaseIn':
        return Curves.fastLinearToSlowEaseIn;
      case 'fastOutSlowIn':
        return Curves.fastOutSlowIn;
      case 'bounceIn':
        return Curves.bounceIn;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'bounceInOut':
        return Curves.bounceInOut;
      case 'linearToEaseOut':
        return Curves.linearToEaseOut;
      case 'slowMiddle':
        return Curves.slowMiddle;
      case 'decelerate':
        return Curves.decelerate;
      case 'ease':
        return Curves.ease;
      case 'easeIn':
        return Curves.easeIn;
      case 'easeOut':
        return Curves.easeOut;
      case 'easeInOut':
        return Curves.easeInOut;
      case 'easeInBack':
        return Curves.easeInBack;
      case 'easeInCirc':
        return Curves.easeInCirc;
      default:
        return null;
    }
  }

  static StrokeCap? toStrokeCap(dynamic value) => switch (value) {
        'round' => StrokeCap.round,
        'butt' => StrokeCap.butt,
        'square' => StrokeCap.square,
        _ => null
      };

  static StackFit toStackFit(dynamic value) => switch (value) {
        'expand' => StackFit.expand,
        'passthrough' => StackFit.passthrough,
        _ => StackFit.loose
      };

  static AlignmentDirectional toStackChildAlignment(String? fit) {
    switch (fit) {
      case 'center':
        return AlignmentDirectional.center;
      case 'topEnd':
        return AlignmentDirectional.topEnd;
      case 'topCenter':
        return AlignmentDirectional.topCenter;
      case 'centerEnd':
        return AlignmentDirectional.centerEnd;
      case 'centerStart':
        return AlignmentDirectional.centerStart;
      case 'bottomStart':
        return AlignmentDirectional.bottomStart;
      case 'bottomCenter':
        return AlignmentDirectional.bottomCenter;
      case 'bottomEnd':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.topStart;
    }
  }

  static VerticalDirection toVerticalDirection(String? value) {
    if (value == null) return VerticalDirection.down;

    switch (value) {
      case 'up':
        return VerticalDirection.up;
      case 'down':
        return VerticalDirection.down;
      default:
        return VerticalDirection.down;
    }
  }

  static Axis toAxis(String? value, {Axis defaultValue = Axis.horizontal}) {
    if (value == null) return defaultValue;

    switch (value) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
        return Axis.vertical;
      default:
        return defaultValue;
    }
  }

  static WrapAlignment toWrapAlignment(String? value,
      {WrapAlignment defaultValue = WrapAlignment.start}) {
    if (value == null) return defaultValue;

    return switch (value) {
      'start' => WrapAlignment.start,
      'end' => WrapAlignment.end,
      'center' => WrapAlignment.center,
      'spaceBetween' => WrapAlignment.spaceBetween,
      'spaceAround' => WrapAlignment.spaceAround,
      'spaceEvenly' => WrapAlignment.spaceEvenly,
      _ => defaultValue
    };
  }

  static WrapCrossAlignment toWrapCrossAlignment(String? value,
      {WrapCrossAlignment defaultValue = WrapCrossAlignment.start}) {
    if (value == null) return defaultValue;

    return switch (value) {
      'start' => WrapCrossAlignment.start,
      'end' => WrapCrossAlignment.end,
      'center' => WrapCrossAlignment.center,
      _ => defaultValue
    };
  }

  static Clip toClip(dynamic value, {Clip defaultValue = Clip.none}) {
    if (value == null) return defaultValue;

    return switch (value) {
      'antiAlias' => Clip.antiAlias,
      'hardEdge' => Clip.hardEdge,
      'antiAliasWithSaveLayer' => Clip.antiAliasWithSaveLayer,
      _ => defaultValue
    };
  }

  static double? getWidth(BuildContext context, dynamic value) {
    return _compute(MediaQuery.of(context).size.width, value);
  }

  static double? getHeight(BuildContext context, dynamic value) {
    return _compute(MediaQuery.of(context).size.height, value);
  }

  static double? _compute(double extent, dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toDouble();

    if (value is! String) {
      return null;
    }

    final s = value.trim();
    if (s.isEmpty) return null;

    if (s.characters.last == '%') {
      final substring = s.substring(0, s.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return extent * (factor / 100);
    }

    return double.tryParse(s);
  }
}
