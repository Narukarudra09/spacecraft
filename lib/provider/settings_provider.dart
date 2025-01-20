import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  String _language = 'English';

  bool get notificationsEnabled => _notificationsEnabled;

  String get language => _language;

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}
