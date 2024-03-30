import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DUIDecoder {
  static MainAxisAlignment? toMainAxisAlginment(String? value) {
    if (value == null) return null;

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

  static MainAxisAlignment toMainAxisAlginmentOrDefault(String? value,
      {required MainAxisAlignment defaultValue}) {
    return toMainAxisAlginment(value) ?? defaultValue;
  }

  static CrossAxisAlignment? toCrossAxisAlignment(String? value) {
    if (value == null) return null;

    return switch (value) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'center' => CrossAxisAlignment.center,
      'stretch' => CrossAxisAlignment.stretch,
      'baseline' => CrossAxisAlignment.baseline,
      _ => null
    };
  }

  static CrossAxisAlignment toCrossAxisAlignmentOrDefault(String? value,
      {required CrossAxisAlignment defaultValue}) {
    return toCrossAxisAlignment(value) ?? defaultValue;
  }

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

  static FontStyle toFontStyle(String? style) {
    switch (style) {
      case 'italic':
        return FontStyle.italic;
    }

    return FontStyle.normal;
  }

  static TextAlign toTextAlign(String? alignment) {
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

  static TextOverflow toTextOverflow(String? overflow) {
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

  static TextDecoration toTextDecoration(String? textDecorationToken) {
    switch (textDecorationToken) {
      case 'underline':
        return TextDecoration.underline;
      case 'overline':
        return TextDecoration.overline;
      case 'lineThrough':
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.none;
    }
  }

  static TextDecorationStyle? toTextDecorationStyle(
      String? textDecorationStyleToken) {
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

  static BoxFit toBoxFit(String? fitValue) => switch (fitValue) {
        'fill' => BoxFit.fill,
        'contain' => BoxFit.contain,
        'cover' => BoxFit.cover,
        'fitWidth' => BoxFit.fitWidth,
        'fitHeight' => BoxFit.fitHeight,
        'scaleDown' => BoxFit.scaleDown,
        _ => BoxFit.none
      };

  static EdgeInsets toEdgeInsets(Map<String, dynamic>? insets) {
    if (insets == null) {
      return EdgeInsets.zero;
    }

    return EdgeInsets.fromLTRB(
      NumDecoder.toDoubleOrDefault(insets['left'], defaultValue: 0),
      NumDecoder.toDoubleOrDefault(insets['top'], defaultValue: 0),
      NumDecoder.toDoubleOrDefault(insets['right'], defaultValue: 0),
      NumDecoder.toDoubleOrDefault(insets['bottom'], defaultValue: 0),
    );
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

  static StrokeCap? toStrokeCap(String? cap) {
    if (cap == null) {
      return null;
    }

    switch (cap) {
      case 'round':
        return StrokeCap.round;
      case 'butt':
        return StrokeCap.butt;
      case 'square':
        return StrokeCap.square;
    }

    return null;
  }

  static StackFit toStackFit(String? fit) {
    switch (fit) {
      case 'expand':
        return StackFit.expand;
      case 'passthrough':
        return StackFit.passthrough;
      default:
        return StackFit.loose;
    }
  }

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
        Axis.horizontal;

      case 'vertical':
        Axis.vertical;
    }

    return defaultValue;
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
}
