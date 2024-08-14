import 'package:talker/talker.dart';

class DUILogger {
  Talker? talker;
  DUILogger(this.talker);

  log(TalkerLog log) {
    talker?.logTyped(log);
  }
}
