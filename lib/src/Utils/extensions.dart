import 'package:flutter/widgets.dart';

import '../../digia_ui.dart';
import '../init/digia_ui.dart';
import '../init/digia_ui_manager.dart';

extension DigiaUILookup on BuildContext {
  DigiaUI? get digiaUi => DigiaUIManager().safeInstance;
  DUIAnalytics? get analyticsHandler => DigiaUIScope.of(this).analyticsHandler;
}
