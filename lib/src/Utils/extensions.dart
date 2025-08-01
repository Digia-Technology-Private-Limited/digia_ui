import 'package:flutter/widgets.dart';

import '../../digia_ui.dart';

extension DigiaUILookup on BuildContext {
  DigiaUI? get digiaUi => DigiaUIManager().safeInstance;
  DUIAnalytics? get analyticsHandler => DigiaUIScope.of(this).analyticsHandler;
}
