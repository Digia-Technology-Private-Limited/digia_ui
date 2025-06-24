import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../network/api_request/api_request.dart';
import 'font_factory.dart';
import 'utils/color_util.dart';

class ResourceProvider extends InheritedWidget {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle?> _textStyles;
  final DUIFontFactory? _fontFactory;
  final Map<String, APIModel> apiModels;
  final Map<String, Color?> _colors;
  final Map<String, Color?> _darkColors;

  final GlobalKey<NavigatorState>? navigatorKey;

  const ResourceProvider({
    super.key,
    required this.icons,
    required this.images,
    required Map<String, TextStyle?> textStyles,
    required DUIFontFactory? fontFactory,
    required this.apiModels,
    required Map<String, Color?> colors,
    required Map<String, Color?> darkColors,
    this.navigatorKey,
    required super.child,
  })  : _colors = colors,
        _darkColors = darkColors,
        _textStyles = textStyles,
        _fontFactory = fontFactory;

  Color? getColor(String key, BuildContext context) =>
      (Theme.of(context).brightness == Brightness.dark
          ? _darkColors
          : _colors)[key] ??
      ColorUtil.fromString(key);

  static ResourceProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ResourceProvider>();
  }

  DUIFontFactory? getFontFactory() => _fontFactory;

  TextStyle? getFontFromToken(String token) => _textStyles[token];

  ImageProvider? getImageProvider(String key) => images[key];

  @override
  bool updateShouldNotify(ResourceProvider oldWidget) => false;
}
