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
    switch (weight) {
      case 'thin':
        return FontWeight.w100;
      case 'extralight':
      case 'extra-light':
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
      String textDecorationStyleToken) {
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

  static AlignmentGeometry? toAlignmentGeometry(String? token) =>
      switch (token) {
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

  static BoxFit toBoxFit(String? fitValue) => switch (fitValue) {
        'fill' => BoxFit.fill,
        'contain' => BoxFit.contain,
        'cover' => BoxFit.cover,
        'fitWidth' => BoxFit.fitWidth,
        'fitHeight' => BoxFit.fitHeight,
        'scaleDown' => BoxFit.scaleDown,
        _ => BoxFit.none
      };
}
