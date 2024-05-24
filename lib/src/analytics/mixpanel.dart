// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
//
// class MixpanelManager {
//   static Mixpanel? instance;
//
//   static Future<Mixpanel> init(
//       String projectToken, String digiaAccessKey) async {
//     if (instance == null) {
//       instance = await Mixpanel.init(projectToken,
//           optOutTrackingDefault: false, trackAutomaticEvents: true);
//       instance?.setLoggingEnabled(true);
//       instance?.registerSuperPropertiesOnce({'projectId': digiaAccessKey});
//       instance?.track('sdk_init');
//     }
//     return instance!;
//   }
// }
