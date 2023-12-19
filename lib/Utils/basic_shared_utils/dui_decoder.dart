import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';
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
}
