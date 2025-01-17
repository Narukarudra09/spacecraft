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
        _tempProfile = profile;
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
      _tempProfile = _tempProfile.copyWith(profilePicture: path);
      notifyListeners();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
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
    _tempProfile = _profile;
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
