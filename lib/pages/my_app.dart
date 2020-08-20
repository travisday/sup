import 'package:sup/pages/fancy_drawer.dart';
import 'package:sup/pages/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/pages/login.dart';
import 'package:sup/provider/users_provider.dart';
import 'package:sup/provider/theme_provider.dart';
import 'package:sup/provider/keyboard_dismisser.dart';
import 'package:sup/pages/home.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  Widget _getFirstRoute(BuildContext context) {
    var state = Provider.of<AuthState>(context);

    if (state is LoggedIn) return FriendProvider(child: FancyDrawer());

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
