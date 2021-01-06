import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sup/api/user_service.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

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
  MessageStream _messageStream = MessageStream.instance;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print(message);
          _messageStream.addMessage(message);
        },
        onLaunch: messageHandler,
        onResume: messageHandler,
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      await userService.setPushToken(token);
      _initialized = true;
    }
  }
}

class MessageStream {
  MessageStream._internal();

  static final MessageStream _instance = MessageStream._internal();

  static MessageStream get instance {
    return _instance;
  }

  final _message = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get messageStream => _message.stream;

  void addMessage(Map<String, dynamic> msg) {
    _message.add(msg);
    return;
  }

  void dispose() {
    _message.close();
  }
}
