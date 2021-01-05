import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sup/api/push_notifications.dart';
import 'package:sup/provider/auth_provider.dart';
import 'package:sup/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'june_lake',
    options: const FirebaseOptions(
      googleAppID: '1:146954790551:ios:d932da53cebf8c9c27ebd2',
      // gcmSenderID: '79601577497',
      apiKey: 'AIzaSyBXfc3LkLyg787g7AGAn5GWNb9e_-6mMiU',
      projectID: 'sup-f0bc0',
    ),
  );
  Firestore(app: app);
  PushNotificationsManager pushy = PushNotificationsManager();
  pushy.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(ChangeNotifierProvider<ThemeProvider>(
    child: AuthProvider(),
    create: (BuildContext context) {
      return ThemeProvider(prefs);
    },
  ));
}
