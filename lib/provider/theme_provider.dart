import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MyThemes { light, dark }

var primaryPurple = Color(0xFF6B64A8);
var purple = MaterialColor(0xFF6B64A8, {
  50: Color(0xFFedecf5),
  100: Color(0xFFd3d1e5),
  200: Color(0xFFb5b2d4),
  300: Color(0xFF9793c2),
  400: Color(0xFF817bb5),
  500: Color(0xFF6b64a8),
  600: Color(0xFF635ca0),
  700: Color(0xFF585297),
  800: Color(0xFF4e488d),
  900: Color(0xFF3c367d),
});

var darkBG = Color(0xFF252529);
var dark = MaterialColor(0xFF252529, {
  50: Color(0xFFA5A5B8),
  100: Color(0xFF9393A3),
  200: Color(0xFF81818F),
  300: Color(0xFF6E6E7A),
  400: Color(0xFF5C5C66),
  500: Color(0xFF494952),
  600: Color(0xFF37373D),
  700: Color(0xFF252529),
  800: Color(0xFF131315),
  900: Color(0xFF000000),
});

var ddt = ThemeData.dark();
var ltt = ThemeData.light();

var darkTheme = ThemeData(
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple[200],
  backgroundColor: dark[800],
  accentColor: Colors.pinkAccent[200],
  canvasColor: dark[700],
  textTheme: ddt.textTheme.copyWith(
    body1: ddt.textTheme.body1.copyWith(fontSize: 16.0),
    body2: ddt.textTheme.body1.copyWith(fontSize: 16.0),
  ),
  chipTheme: ddt.chipTheme.copyWith(
    backgroundColor: dark[600],
    secondarySelectedColor: Colors.deepPurple[200],
    selectedColor: Colors.pinkAccent,
    secondaryLabelStyle: ddt.chipTheme.secondaryLabelStyle.copyWith(
      color: Colors.white,
    ),
  ),
);

var lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF6B64A8),
  accentColor: Colors.pinkAccent,
  canvasColor: Color(0xFFF2F2F7),
  backgroundColor: Color(0xFF6B64A8),
  textTheme: ltt.textTheme.copyWith(
    body1: ltt.textTheme.body1.copyWith(fontSize: 16.0),
    body2: ltt.textTheme.body1.copyWith(fontSize: 16.0),
  ),
  chipTheme: ltt.chipTheme.copyWith(
    secondarySelectedColor: Color(0xFF6B64A8),
    selectedColor: Colors.pinkAccent,
    secondaryLabelStyle: ltt.chipTheme.secondaryLabelStyle.copyWith(
      color: Colors.white,
    ),
  ),
);

class ThemeProvider with ChangeNotifier {
  //List all themes. Here we have two themes: light and dark
  static final List<ThemeData> themeData = [lightTheme, darkTheme];
  SharedPreferences prefs;
  MyThemes _currentTheme;
  ThemeData _currentThemeData;

  ThemeProvider(this.prefs) {
    String theme;
    if (prefs.containsKey("theme")) {
      theme = prefs.getString("theme");
      print("restoring theme $theme from saved data");
    } else {
      theme = "light";
    }
    this.currentTheme = theme == "light" ? MyThemes.light : MyThemes.dark;
  }

  void switchTheme() => currentTheme == MyThemes.light
      ? currentTheme = MyThemes.dark
      : currentTheme = MyThemes.light;

  set currentTheme(MyThemes theme) {
    if (theme != null) {
      _currentTheme = theme;
      _currentThemeData =
          currentTheme == MyThemes.light ? themeData[0] : themeData[1];
      notifyListeners();
      prefs.setString(
          "theme", currentTheme == MyThemes.light ? "light" : "dark");
    }
  }

  MyThemes get currentTheme => _currentTheme;
  ThemeData get currentThemeData => _currentThemeData;
}
