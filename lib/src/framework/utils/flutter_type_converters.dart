import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'color_util.dart';
import 'functional_util.dart';
import 'num_util.dart';

abstract class To {
  static MainAxisAlignment? mainAxisAlginment(dynamic value) => switch (value) {
        // Map string values to corresponding MainAxisAlignment constants
        'start' => MainAxisAlignment.start,
        'end' => MainAxisAlignment.end,
        'center' => MainAxisAlignment.center,
        'spaceBetween' => MainAxisAlignment.spaceBetween,
        'spaceAround' => MainAxisAlignment.spaceAround,
        'spaceEvenly' => MainAxisAlignment.spaceEvenly,
        // Return null for any unrecognized input
        _ => null
      };

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

  static FontWeight fontWeight(dynamic value) => switch (value) {
        'thin' => FontWeight.w100,
        'extralight' || 'extra-light' || 'extra_light' => FontWeight.w200,
        'light' => FontWeight.w300,
        'regular' => FontWeight.normal,
        'medium' => FontWeight.w500,
        'semibold' || 'semi-bold' => FontWeight.w600,
        'bold' => FontWeight.w700,
        'extrabold' || 'extra-bold' => FontWeight.w800,
        'black' => FontWeight.w900,
        _ => FontWeight.normal,
      };

  static FontStyle fontStyle(dynamic value) => switch (value) {
        'italic' || true => FontStyle.italic,
        _ => FontStyle.normal
      };

  static TextAlign toTextAlign(dynamic value) => switch (value) {
        'right' => TextAlign.right,
        'left' => TextAlign.left,
        'center' => TextAlign.center,
        'end' => TextAlign.end,
        'justify' => TextAlign.justify,
        _ => TextAlign.start,
      };

  static TextOverflow toTextOverflow(dynamic value) => switch (value) {
        'fade' => TextOverflow.fade,
        'visible' => TextOverflow.visible,
        'clip' => TextOverflow.clip,
        'ellipsis' => TextOverflow.ellipsis,
        _ => TextOverflow.clip,
      };

  static TextDecoration? toTextDecoration(dynamic value) => switch (value) {
        'underline' => TextDecoration.underline,
        'overline' => TextDecoration.overline,
        'lineThrough' => TextDecoration.lineThrough,
        'none' => TextDecoration.none,
        _ => null,
      };

  static TextDecorationStyle? toTextDecorationStyle(dynamic value) =>
      switch (value) {
        'dashed' => TextDecorationStyle.dashed,
        'dotted' => TextDecorationStyle.dotted,
        'double' => TextDecorationStyle.double,
        'solid' => TextDecorationStyle.solid,
        'wavy' => TextDecorationStyle.wavy,
        _ => null,
      };

  static LaunchMode toUriLaunchMode(dynamic value) => switch (value) {
        'inAppWebView' || 'inApp' => LaunchMode.inAppWebView,
        'externalApplication' || 'external' => LaunchMode.externalApplication,
        'externalNonBrowserApplication' =>
          LaunchMode.externalNonBrowserApplication,
        _ => LaunchMode.platformDefault
      };

  static Alignment? alignment(dynamic value) {
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
      final xNullable = NumUtil.toDouble(value['x']);
      final yNullable = NumUtil.toDouble(value['y']);
      return (xNullable, yNullable).maybe((p0, p1) => Alignment(p0, p1));
    }

    return null;
  }

  static BoxFit toBoxFit(dynamic value) => switch (value) {
        'fill' => BoxFit.fill,
        'contain' => BoxFit.contain,
        'cover' => BoxFit.cover,
        'fitWidth' => BoxFit.fitWidth,
        'fitHeight' => BoxFit.fitHeight,
        'scaleDown' => BoxFit.scaleDown,
        _ => BoxFit.none
      };

  /// Converts a dynamic value to [EdgeInsets].
  ///
  /// Supports various input types:
  /// - List of numbers
  /// - String of comma-separated numbers
  /// - Single number
  /// - Map with specific keys
  ///
  /// Returns [or] (default: EdgeInsets.zero) if conversion fails.
  static EdgeInsets edgeInsets(dynamic value,
      {EdgeInsets or = EdgeInsets.zero}) {
    // Return default value if input is null
    if (value == null) return or;

    // Handle List input
    if (value is List) {
      return _toEdgeInsetsFromList(
              value.map((e) => NumUtil.toDouble(e)).nonNulls.toList()) ??
          or;
    }

    // Handle String input (comma-separated values)
    if (value is String) {
      return _toEdgeInsetsFromList(value
              .split(',')
              .map((e) => NumUtil.toDouble(e))
              .nonNulls
              .toList()) ??
          or;
    }

    // Handle single number input
    if (value is num) {
      return _toEdgeInsetsFromList([value.toDouble()]) ?? or;
    }

    // Handle Map input
    if (value is Map<String, dynamic>) {
      // Check for 'all' key
      if (value['all'] != null) {
        return EdgeInsets.all(NumUtil.toDouble(value['all']) ?? 0);
      }

      // Check for 'horizontal' and 'vertical' keys
      if (value['horizontal'] != null && value['vertical'] != null) {
        return EdgeInsets.symmetric(
            horizontal: NumUtil.toDouble(value['horizontal']) ?? 0,
            vertical: NumUtil.toDouble(value['vertical']) ?? 0);
      }

      // Use LTRB values
      return EdgeInsets.fromLTRB(
        NumUtil.toDouble(value['left']) ?? 0,
        NumUtil.toDouble(value['top']) ?? 0,
        NumUtil.toDouble(value['right']) ?? 0,
        NumUtil.toDouble(value['bottom']) ?? 0,
      );
    }

    // Return default value if no conversion was possible
    return or;
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
    final doubleValue = NumUtil.toDouble(value);
    if (doubleValue != null) return Radius.circular(doubleValue);

    final doubleValueFromRadii = NumUtil.toDouble(value['radius']);
    if (doubleValueFromRadii != null) {
      return Radius.circular(doubleValueFromRadii);
    }

    final xNullable = value['x'];
    final yNullable = value['y'];

    if (xNullable != null && yNullable != null) {
      return Radius.elliptical(
        NumUtil.toDouble(xNullable) ?? 0.0,
        NumUtil.toDouble(yNullable) ?? 0.0,
      );
    }

    return Radius.zero;
  }

  static Border? border(
      ({
        String? style,
        double? width,
        Color? color,
      })? border) {
    if (border == null || border.style != 'solid') {
      return null;
    }

    return Border.all(
      style: BorderStyle.solid,
      width: border.width ?? 1.0,
      color: border.color ?? ColorUtil.fromHexString('#000000'),
    );
  }

  static BorderRadius borderRadius(dynamic value) {
    if (value == null) return BorderRadius.zero;

    if (value is List) {
      return _toBorderRadiusFromList(
              value.map((e) => NumUtil.toDouble(e) ?? 0).toList()) ??
          BorderRadius.zero;
    }

    if (value is String) {
      return _toBorderRadiusFromList(
              value.split(',').map((e) => NumUtil.toDouble(e) ?? 0).toList()) ??
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

    return BorderRadius.zero;
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

  static Curve? toCurve(String? curveString) => switch (curveString) {
        'easeInCubic' => Curves.easeInCubic,
        'easeInExpo' => Curves.easeInExpo,
        'easeOutBack' => Curves.easeOutBack,
        'easeInOutCirc' => Curves.easeInOutCirc,
        'easeInOutCubic' => Curves.easeInOutCubic,
        'easeInOutCubicEmphasized' => Curves.easeInOutCubicEmphasized,
        'easeInOutExpo' => Curves.easeInOutExpo,
        'easeInOutQuad' => Curves.easeInOutQuad,
        'easeInOutQuart' => Curves.easeInOutQuart,
        'easeInOutQuint' => Curves.easeInOutQuint,
        'easeInOutSine' => Curves.easeInOutSine,
        'easeInQuad' => Curves.easeInQuad,
        'easeInQuart' => Curves.easeInQuart,
        'easeInQuint' => Curves.easeInQuint,
        'easeInSine' => Curves.easeInSine,
        'easeInToLinear' => Curves.easeInToLinear,
        'easeOutCirc' => Curves.easeOutCirc,
        'easeOutCubic' => Curves.easeOutCubic,
        'easeOutExpo' => Curves.easeOutExpo,
        'easeOutQuad' => Curves.easeOutQuad,
        'easeOutQuart' => Curves.easeOutQuart,
        'easeOutQuint' => Curves.easeOutQuint,
        'easeOutSine' => Curves.easeOutSine,
        'elasticInOut' => Curves.elasticInOut,
        'elasticIn' => Curves.elasticIn,
        'elasticOut' => Curves.elasticOut,
        'fastEaselnToSlowOut' => Curves.fastEaseInToSlowEaseOut,
        'fastLinearToSlowEaseIn' => Curves.fastLinearToSlowEaseIn,
        'fastOutSlowIn' => Curves.fastOutSlowIn,
        'bounceIn' => Curves.bounceIn,
        'bounceOut' => Curves.bounceOut,
        'bounceInOut' => Curves.bounceInOut,
        'linearToEaseOut' => Curves.linearToEaseOut,
        'slowMiddle' => Curves.slowMiddle,
        'decelerate' => Curves.decelerate,
        'ease' => Curves.ease,
        'easeIn' => Curves.easeIn,
        'easeOut' => Curves.easeOut,
        'easeInOut' => Curves.easeInOut,
        'easeInBack' => Curves.easeInBack,
        'easeInCirc' => Curves.easeInCirc,
        _ => null,
      };
}
