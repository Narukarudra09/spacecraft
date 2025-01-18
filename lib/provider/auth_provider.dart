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

  Profile _tempProfile = Profile(
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

  Profile get tempProfile => _tempProfile;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  String? get error => _error;

  AuthProvider() {
    loadUserDataFromPreferences();
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
      _tempProfile = profile;
      _isAuthenticated = true;
      _error = null;
      await _saveUserDataToPreferences();
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
        _tempProfile = profile;
        await _saveUserDataToPreferences();
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

  void updateTempProfile(Profile profile) {
    _tempProfile = profile;
    notifyListeners();
  }

  Future<void> saveProfileChanges() async {
    try {
      _setLoading(true);
      _profile = _tempProfile;
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'fullName': _tempProfile.fullName,
        'email': _tempProfile.email,
        'dateOfBirth': _tempProfile.dateOfBirth.toIso8601String(),
        'gender': _tempProfile.gender,
        'profilePicture': _tempProfile.profilePicture,
      });
      await _saveUserDataToPreferences();
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
    _tempProfile = Profile(
      fullName: '',
      dateOfBirth: DateTime.now(),
      email: '',
      gender: '',
      profilePicture: '',
    );
    notifyListeners();
  }

  bool validateProfile() {
    return _tempProfile.fullName.isNotEmpty &&
        _tempProfile.email.isNotEmpty &&
        _tempProfile.email.contains('@') &&
        _tempProfile.gender.isNotEmpty;
  }

  Future<void> _saveUserDataToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _profile.fullName);
    await prefs.setString('email', _profile.email);
    await prefs.setString(
        'dateOfBirth', _profile.dateOfBirth.toIso8601String());
    await prefs.setString('gender', _profile.gender);
    await prefs.setString('profilePicture', _profile.profilePicture);
    print('User data saved to preferences: $_profile');
  }

  Future<void> loadUserDataFromPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _profile = Profile(
        fullName: prefs.getString('fullName') ?? '',
        email: prefs.getString('email') ?? '',
        dateOfBirth: DateTime.parse(
            prefs.getString('dateOfBirth') ?? DateTime.now().toIso8601String()),
        gender: prefs.getString('gender') ?? '',
        profilePicture: prefs.getString('profilePicture') ?? '',
      );
      _tempProfile = _profile;
      print('User data loaded from preferences: $_profile');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Error loading user data from preferences: $_error');
    }
  }

  Future<void> _clearUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('dateOfBirth');
    await prefs.remove('gender');
    await prefs.remove('profilePicture');
    print('User data cleared from preferences');
  }
}
