import 'package:flutter/cupertino.dart';

class ControllerTheme extends ChangeNotifier {
  static final instance = ControllerTheme();
  bool isDarkTheme = false;

  void changeTheme(bool isDark) {
    this.isDarkTheme = isDark;
    notifyListeners();
  }
}
