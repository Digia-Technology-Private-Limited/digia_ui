import 'package:uuid/uuid.dart';

import 'src/preferences_store.dart';

class DUISettings {
  static final DUISettings _instance = DUISettings._();
  static const String _uuidKey = 'uuid';

  DUISettings._();

  static DUISettings get instance => _instance;

  String getUuid() {
    String? uuid = PreferencesStore.instance.read<String>(_uuidKey);
    if (uuid == null) {
      uuid = const Uuid().v4();
      PreferencesStore.instance.write(_uuidKey, uuid);
    }

    return uuid;
  }
}
