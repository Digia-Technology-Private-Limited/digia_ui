import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import '../framework/digia_ui_scope.dart';
import '../init/digia_ui.dart';
import '../init/digia_ui_manager.dart';

extension DigiaUILookup on BuildContext {
  DigiaUI? get digiaUi => DigiaUIManager().safeInstance;
  DUIAnalytics? get analyticsHandler => DigiaUIScope.of(this).analyticsHandler;
}
