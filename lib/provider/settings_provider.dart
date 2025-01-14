import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  String _language = 'English';
  bool _isAdmin = false;

  bool get notificationsEnabled => _notificationsEnabled;

  String get language => _language;

  bool get isAdmin => _isAdmin;

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setAdminStatus(bool status) {
    _isAdmin = status;
    notifyListeners();
  }

  void toggleAdmin() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }
}
