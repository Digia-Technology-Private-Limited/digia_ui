import 'package:flutter/widgets.dart';

import '../../../dui_logger.dart';
import '../../expr/scope_context.dart';
import 'action.dart' as an;

abstract class ActionProcessor<T extends an.Action> {
  DUILogger? logger;
  Map<String, Object?>? metaData;

  ActionProcessor({this.logger, this.metaData});

  logAction(String actionType, Map<String, Object?> actionData) {
    logger?.log(
      type: LogType.action,
      data: {
        'entitySlug': metaData?['entitySlug'],
        'actionType': actionType,
        'actionData': actionData,
      },
    );
  }

  Future<Object?>? execute(
    BuildContext context,
    T action,
    ScopeContext? scopeContext,
  );
}
