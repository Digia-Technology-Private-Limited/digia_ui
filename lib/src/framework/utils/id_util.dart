import 'package:uuid/uuid.dart';

import '../actions/base/action.dart';

class IdGen {
  static final _uuid = Uuid();

  static String newFlowId() => 'flow-${_uuid.v4()}';
  static ActionId newActionId() => ActionId('act-${_uuid.v4()}');
}
