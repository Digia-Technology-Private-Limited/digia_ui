import 'package:flutter/widgets.dart';

import '../../network/api_request/api_request.dart';
import '../utils/color_util.dart';
import 'message_handler.dart';

class ResourceProvider extends InheritedWidget {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle> textStyles;
  final Map<String, APIModel> apiModels;
  final Map<String, Color?> _colors;
  final DUIMessageHandler? messageHandler;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ResourceProvider({
    super.key,
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.apiModels,
    required Map<String, Color?> colors,
    required this.messageHandler,
    this.navigatorKey,
    required super.child,
  }) : _colors = colors;

  Color? getColor(String key) => _colors[key] ?? ColorUtil.fromString(key);

  static ResourceProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ResourceProvider>();
  }

  @override
  bool updateShouldNotify(ResourceProvider oldWidget) => false;
}
