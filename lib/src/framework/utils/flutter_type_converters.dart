import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/custom_flutter_types.dart';
import 'color_util.dart';
import 'functional_util.dart';
import 'json_util.dart';
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

  static CrossAxisAlignment? crossAxisAlignment(dynamic value) =>
      switch (value) {
        'start' => CrossAxisAlignment.start,
        'end' => CrossAxisAlignment.end,
        'center' => CrossAxisAlignment.center,
        'stretch' => CrossAxisAlignment.stretch,
        'baseline' => CrossAxisAlignment.baseline,
        _ => null
      };

  static MainAxisSize? mainAxisSize(dynamic value) => switch (value) {
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

  static TextAlign textAlign(dynamic value) => switch (value) {
        'right' => TextAlign.right,
        'left' => TextAlign.left,
        'center' => TextAlign.center,
        'end' => TextAlign.end,
        'justify' => TextAlign.justify,
        _ => TextAlign.start,
      };

  static TextOverflow textOverflow(dynamic value) => switch (value) {
        'fade' => TextOverflow.fade,
        'visible' => TextOverflow.visible,
        'clip' => TextOverflow.clip,
        'ellipsis' => TextOverflow.ellipsis,
        _ => TextOverflow.clip,
      };

  static TextDecoration? textDecoration(dynamic value) => switch (value) {
        'underline' => TextDecoration.underline,
        'overline' => TextDecoration.overline,
        'lineThrough' => TextDecoration.lineThrough,
        'none' => TextDecoration.none,
        _ => null,
      };

  static TextDecorationStyle? textDecorationStyle(dynamic value) =>
      switch (value) {
        'dashed' => TextDecorationStyle.dashed,
        'dotted' => TextDecorationStyle.dotted,
        'double' => TextDecorationStyle.double,
        'solid' => TextDecorationStyle.solid,
        'wavy' => TextDecorationStyle.wavy,
        _ => null,
      };

  static LaunchMode uriLaunchMode(dynamic value) => switch (value) {
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

  static BoxFit boxFit(dynamic value) => switch (value) {
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

  static ScrollPhysics? scrollPhysics(dynamic physics) {
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

  static AlignmentDirectional stackChildAlignment(String? fit) => switch (fit) {
        'center' => AlignmentDirectional.center,
        'topEnd' => AlignmentDirectional.topEnd,
        'topCenter' => AlignmentDirectional.topCenter,
        'centerEnd' => AlignmentDirectional.centerEnd,
        'centerStart' => AlignmentDirectional.centerStart,
        'bottomStart' => AlignmentDirectional.bottomStart,
        'bottomCenter' => AlignmentDirectional.bottomCenter,
        'bottomEnd' => AlignmentDirectional.bottomEnd,
        _ => AlignmentDirectional.topStart
      };

  static StackFit stackFit(dynamic value) => switch (value) {
        'expand' => StackFit.expand,
        'passthrough' => StackFit.passthrough,
        _ => StackFit.loose
      };

  static Axis? axis(dynamic value) => switch (value) {
        'horizontal' => Axis.horizontal,
        'vertical' => Axis.vertical,
        _ => null
      };

  static Clip? clip(dynamic value) => switch (value) {
        'antiAlias' => Clip.antiAlias,
        'hardEdge' => Clip.hardEdge,
        'antiAliasWithSaveLayer' => Clip.antiAliasWithSaveLayer,
        _ => null
      };

  static StrokeCap? strokeCap(dynamic value) => switch (value) {
        'round' => StrokeCap.round,
        'butt' => StrokeCap.butt,
        'square' => StrokeCap.square,
        _ => null
      };

  static StrokeAlign? strokeAlign(dynamic string) => switch (string) {
        'inside' => StrokeAlign.inside,
        'outside' => StrokeAlign.outside,
        'center' => StrokeAlign.center,
        _ => null
      };

  static BorderPattern? borderPattern(dynamic value) => switch (value) {
        'solid' => BorderPattern.solid,
        'dotted' => BorderPattern.dotted,
        'dashed' => BorderPattern.dashed,
        _ => null
      };

  static WrapAlignment? wrapAlignment(dynamic value) => switch (value) {
        'start' => WrapAlignment.start,
        'end' => WrapAlignment.end,
        'center' => WrapAlignment.center,
        'spaceBetween' => WrapAlignment.spaceBetween,
        'spaceAround' => WrapAlignment.spaceAround,
        'spaceEvenly' => WrapAlignment.spaceEvenly,
        _ => null
      };

  static WrapCrossAlignment? wrapCrossAlignment(String? value) =>
      switch (value) {
        'start' => WrapCrossAlignment.start,
        'end' => WrapCrossAlignment.end,
        'center' => WrapCrossAlignment.center,
        _ => null
      };

  static VerticalDirection? verticalDirection(String? value) => switch (value) {
        'up' => VerticalDirection.up,
        'down' => VerticalDirection.down,
        _ => null
      };

  static List<double>? dashPattern(dynamic jsonDashPattern) {
    if (jsonDashPattern == null || jsonDashPattern is! String) {
      return null;
    }
    final parsed = tryJsonDecode(jsonDashPattern) ?? jsonDashPattern;

    if (parsed is! List) return null;

    return parsed.map((e) => NumUtil.toDouble(e)).nonNulls.toList();
  }

  static ExpandablePanelBodyAlignment? expandablePanelBodyAlignment(
          dynamic value) =>
      switch (value) {
        'left' => ExpandablePanelBodyAlignment.left,
        'right' => ExpandablePanelBodyAlignment.right,
        'center' => ExpandablePanelBodyAlignment.center,
        _ => null
      };

  static ExpandablePanelIconPlacement? expandablePanelIconPlacement(
          dynamic value) =>
      switch (value) {
        'left' => ExpandablePanelIconPlacement.left,
        'right' => ExpandablePanelIconPlacement.right,
        _ => null
      };

  static ExpandablePanelHeaderAlignment? expandablePanelHeaderAlignment(
          dynamic value) =>
      switch (value) {
        'top' => ExpandablePanelHeaderAlignment.top,
        'bottom' => ExpandablePanelHeaderAlignment.bottom,
        'center' => ExpandablePanelHeaderAlignment.center,
        _ => null
      };

  static OutlinedBorder? buttonShape(
      dynamic value, Color? Function(String) toColor) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return switch (value) {
        'stadium' => const StadiumBorder(),
        'circle' => const CircleBorder(),
        'none' => null,
        'roundedRect' || _ => const RoundedRectangleBorder()
      };
    }

    if (value is! Map) return null;

    final shape = value['value'] as String?;
    final borderColor =
        (value['borderColor'] as String?).maybe(toColor) ?? Colors.transparent;
    final borderWidth = NumUtil.toDouble(value['borderWidth']) ?? 1.0;
    final borderStyle = (value['borderStyle'] == 'solid')
        ? BorderStyle.solid
        : BorderStyle.none;
    final side =
        BorderSide(color: borderColor, width: borderWidth, style: borderStyle);

    return switch (shape) {
      'stadium' => StadiumBorder(side: side),
      'circle' => CircleBorder(
          eccentricity: NumUtil.toDouble(value['eccentricity']) ?? 0.0,
          side: side),
      'roundedRect' || _ => RoundedRectangleBorder(
          borderRadius: borderRadius(value['borderRadius']), side: side)
    };
  }

  static Gradient? gradient(
    Map<String, Object?>? data, {
    required Color? Function(Object?) evalColor,
  }) {
    if (data == null) return null;

    final type = as$<String>(data['type']);

    switch (type) {
      case 'linear':
        final colors = (data['colorList'] as List?)
            ?.map(
                (e) => evalColor(as$<String>(e['color'])) ?? Colors.transparent)
            .nonNulls
            .toList();

        if (colors == null || colors.isEmpty) return null;

        final stops = (data['colorList'] as List?)
            ?.map((e) => NumUtil.toDouble(e['stop']))
            .nonNulls
            .toList();

        final rotationInRadians = NumUtil.toInt(data['angle'])
            .maybe((p0) => GradientRotation(p0 / 180.0 * math.pi));

        return LinearGradient(
            colors: colors,
            stops: stops?.length == colors.length ? stops! : null,
            transform: rotationInRadians);

      default:
        return null;
    }
  }
}
