import 'package:flutter/material.dart';
import 'package:fiveminutejournal/api/auth.dart';
import 'package:fiveminutejournal/pages/fancy_drawer.dart';
import 'package:fiveminutejournal/pages/login.dart';
import 'package:fiveminutejournal/provider/log_provider.dart';
import 'package:fiveminutejournal/provider/theme_provider.dart';
import 'package:fiveminutejournal/provider/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  Widget _getFirstRoute(BuildContext context) {
    var state = Provider.of<AuthState>(context);

    if (state is LoggedIn) return LogProvider(child: FancyDrawer());

    if (state is LoggedOut) return LoginPage();

    return Container(color: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: 'Transition Demo',
        home: _getFirstRoute(context),
        theme: Provider.of<ThemeProvider>(context).currentThemeData,
      ),
    );
  }
}
