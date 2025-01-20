import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref('Feedback');
  final String _language = 'English';

  bool get notificationsEnabled => _notificationsEnabled;

  String get language => _language;

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  Future<void> submitFeedback(String feedback, BuildContext context) async {
    try {
      await _databaseRef.child('feedback').push().set({
        'email': Provider.of<AuthProvider>(context, listen: false)
            .profile
            .email
            .toString(),
        'message': feedback,
        'id': DateTime.now().toIso8601String(),
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
