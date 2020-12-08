import 'package:firebase_messaging/firebase_messaging.dart';

Future<dynamic> messageHandler(Map<String, dynamic> message) {
  print(message);
  return Future(null);
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: messageHandler,
        onLaunch: messageHandler,
        onResume: messageHandler,
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      //print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}
