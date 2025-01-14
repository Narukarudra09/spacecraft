import 'package:flutter/material.dart';

import '../models/profile.dart';

class UserProvider with ChangeNotifier {
  Profile _profile = Profile(
    fullName: "",
    dateOfBirth: DateTime.now(),
    email: '',
    gender: '',
    profilePicture: '',
  );

  Profile get profile => _profile;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateProfile(Profile profile) {
    try {
      _setLoading(true);
      _profile = profile;
      notifyListeners();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  void updateProfileField<T>(String field, T value) {
    try {
      _setLoading(true);
      switch (field) {
        case 'fullName':
          _profile = _profile.copyWith(fullName: value as String);
        case 'email':
          _profile = _profile.copyWith(email: value as String);
        case 'dateOfBirth':
          _profile = _profile.copyWith(dateOfBirth: value as DateTime);
        case 'gender':
          _profile = _profile.copyWith(gender: value as String);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  void updateProfilePicture(String path) {
    try {
      _setLoading(true);
      _profile = _profile.copyWith(profilePicture: path);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  void resetProfile() {
    _profile = Profile(
      fullName: '',
      dateOfBirth: DateTime.now(),
      email: '',
      gender: '',
      profilePicture: '',
    );
    notifyListeners();
  }

  bool validateProfile() {
    return _profile.fullName.isNotEmpty &&
        _profile.email.isNotEmpty &&
        _profile.email.contains('@') &&
        _profile.gender.isNotEmpty;
  }
}
