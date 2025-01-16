import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import '../screens/auth/login_screen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Profile _profile = Profile(
    fullName: "",
    dateOfBirth: DateTime.now(),
    email: '',
    gender: '',
    profilePicture: '',
  );

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  Profile get profile => _profile;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  String? get error => _error;

  AuthProvider() {
    _loadUserDataFromPreferences();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
  }) async {
    try {
      _setLoading(true);

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile
      final profile = Profile(
        fullName: fullName,
        email: email,
        dateOfBirth: dateOfBirth,
        gender: gender,
        profilePicture: '',
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'profilePicture': '',
      });

      _profile = profile;
      _isAuthenticated = true;
      _error = null;
      _saveUserDataToPreferences();
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user profile from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        final profile = Profile(
          fullName: data['fullName'],
          email: data['email'],
          dateOfBirth: DateTime.parse(data['dateOfBirth']),
          gender: data['gender'],
          profilePicture: data['profilePicture'],
        );

        _profile = profile;
        _saveUserDataToPreferences();
        notifyListeners();
      }

      _isAuthenticated = true;
      _error = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void logout(BuildContext context) {
    _isAuthenticated = false;
    resetProfile();
    _clearUserDataFromPreferences();
    _auth.signOut().then((onValue) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
    notifyListeners();
  }

  void updateProfile(Profile profile) {
    try {
      _setLoading(true);
      _profile = profile;
      _saveUserDataToPreferences();
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
          break;
        case 'email':
          _profile = _profile.copyWith(email: value as String);
          break;
        case 'dateOfBirth':
          _profile = _profile.copyWith(dateOfBirth: value as DateTime);
          break;
        case 'gender':
          _profile = _profile.copyWith(gender: value as String);
          break;
      }
      _saveUserDataToPreferences();
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
      _saveUserDataToPreferences();
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

  Future<void> _saveUserDataToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _profile.fullName);
    await prefs.setString('email', _profile.email);
    await prefs.setString(
        'dateOfBirth', _profile.dateOfBirth.toIso8601String());
    await prefs.setString('gender', _profile.gender);
    await prefs.setString('profilePicture', _profile.profilePicture);
  }

  Future<void> _loadUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profile = Profile(
      fullName: prefs.getString('fullName') ?? '',
      email: prefs.getString('email') ?? '',
      dateOfBirth: DateTime.parse(
          prefs.getString('dateOfBirth') ?? DateTime.now().toIso8601String()),
      gender: prefs.getString('gender') ?? '',
      profilePicture: prefs.getString('profilePicture') ?? '',
    );
    notifyListeners();
  }

  Future<void> _clearUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('dateOfBirth');
    await prefs.remove('gender');
    await prefs.remove('profilePicture');
  }
}
