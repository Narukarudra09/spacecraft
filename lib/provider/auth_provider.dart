import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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

  Future<void> updateProfile(Profile profile) async {
    try {
      _setLoading(true);
      _profile = profile;
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'fullName': profile.fullName,
        'email': profile.email,
        'dateOfBirth': profile.dateOfBirth.toIso8601String(),
        'gender': profile.gender,
        'profilePicture': profile.profilePicture,
      });
      _saveUserDataToPreferences();
      notifyListeners();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfileField<T>(String field, T value) async {
    try {
      _setLoading(true);
      switch (field) {
        case 'fullName':
          _profile = _profile.copyWith(fullName: value as String);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'fullName': value});
          break;
        case 'email':
          _profile = _profile.copyWith(email: value as String);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'email': value});
          break;
        case 'dateOfBirth':
          _profile = _profile.copyWith(dateOfBirth: value as DateTime);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'dateOfBirth': (value as DateTime).toIso8601String()});
          break;
        case 'gender':
          _profile = _profile.copyWith(gender: value as String);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'gender': value});
          break;
        case 'profilePicture':
          _profile = _profile.copyWith(profilePicture: value as String);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'profilePicture': value});
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

  Future<void> updateProfilePicture(String path) async {
    try {
      _setLoading(true);
      File file = File(path);
      if (!await file.exists()) {
        // Download the image from Firestore if it doesn't exist
        final Reference storageReference =
            FirebaseStorage.instance.ref().child(path);
        final String url = await storageReference.getDownloadURL();
        final http.Response response = await http.get(Uri.parse(url));
        final Directory tempDir = await getApplicationDocumentsDirectory();
        final String tempPath = '${tempDir.path}/${path.split('/').last}';
        await File(tempPath).writeAsBytes(response.bodyBytes);
        path = tempPath;
      }
      _profile = _profile.copyWith(profilePicture: path);
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'profilePicture': path});
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

  Future<void> loadUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profilePicturePath = prefs.getString('profilePicture');
    if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
      File file = File(profilePicturePath);
      if (!await file.exists()) {
        // Download the image from Firestore if it doesn't exist
        final Reference storageReference =
            FirebaseStorage.instance.ref().child(profilePicturePath);
        final String url = await storageReference.getDownloadURL();
        final http.Response response = await http.get(Uri.parse(url));
        final Directory tempDir = await getApplicationDocumentsDirectory();
        final String tempPath =
            '${tempDir.path}/${profilePicturePath.split('/').last}';
        await File(tempPath).writeAsBytes(response.bodyBytes);
        profilePicturePath = tempPath;
      }
    }
    _profile = Profile(
      fullName: prefs.getString('fullName') ?? '',
      email: prefs.getString('email') ?? '',
      dateOfBirth: DateTime.parse(
          prefs.getString('dateOfBirth') ?? DateTime.now().toIso8601String()),
      gender: prefs.getString('gender') ?? '',
      profilePicture: profilePicturePath ?? '',
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
