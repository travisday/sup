import 'package:flutter/material.dart';
import 'package:fiveminutejournal/api/auth.dart';
import 'package:fiveminutejournal/pages/my_app.dart';
import 'package:provider/provider.dart';

class AuthProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provide streams to the app to watch
    return StreamProvider<AuthState>.value(
      value: auth.status,
      child: MyApp(),
    );
  }
}
