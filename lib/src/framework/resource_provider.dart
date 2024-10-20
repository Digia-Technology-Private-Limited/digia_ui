import 'package:flutter/widgets.dart';

import '../network/api_request/api_request.dart';
import 'base/message_handler.dart';
import 'utils/color_util.dart';

class ResourceProvider extends InheritedWidget {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle?> _textStyles;
  final Map<String, APIModel> apiModels;
  final Map<String, Color?> _colors;
  final DUIMessageHandler? messageHandler;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ResourceProvider({
    super.key,
    required this.icons,
    required this.images,
    required Map<String, TextStyle?> textStyles,
    required this.apiModels,
    required Map<String, Color?> colors,
    required this.messageHandler,
    this.navigatorKey,
    required super.child,
  })  : _colors = colors,
        _textStyles = textStyles;

  Color? getColor(String key) => _colors[key] ?? ColorUtil.fromString(key);

  static ResourceProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ResourceProvider>();
  }

  TextStyle? getFontFromToken(String token) => _textStyles[token];

  ImageProvider? getImageProvider(String key) => images[key];

  @override
  bool updateShouldNotify(ResourceProvider oldWidget) => false;
}
