import 'package:flutter/widgets.dart';

import '../../network/api_request/api_request.dart';

class ResourceProvider extends InheritedWidget {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle> textStyles;
  final Map<String, APIModel> apiModels;
  final Map<String, Color?> colors;

  // final DUIMessageHandler onMessageReceived;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ResourceProvider({
    super.key,
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.apiModels,
    required this.colors,
    // required this.onMessageReceived,
    this.navigatorKey,
    required super.child,
  });

  static ResourceProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ResourceProvider>();
  }

  @override
  bool updateShouldNotify(ResourceProvider oldWidget) => false;
}
