import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
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
    required String profilePicture,
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
        profilePicture: profilePicture,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'profilePicture': profilePicture,
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
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
      String? fullName = prefs.getString('fullName');
      String? email = prefs.getString('email');
      String? dateOfBirth = prefs.getString('dateOfBirth');
      String? gender = prefs.getString('gender');
      String? profilePicture = prefs.getString('profilePicture');

      if (fullName != null &&
          email != null &&
          dateOfBirth != null &&
          gender != null) {
        _profile = Profile(
          fullName: fullName,
          email: email,
          dateOfBirth: DateTime.parse(dateOfBirth),
          gender: gender,
          profilePicture: profilePicture ?? '',
        );
        _tempProfile = _profile;
        print('User data loaded from preferences: $_profile');
      } else {
        // If data is not found in preferences, try to fetch from Firestore
        await _fetchUserDataFromFirestore();
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Error loading user data from preferences: $_error');
    }
  }

  Future<void> _fetchUserDataFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          _profile = Profile(
            fullName: data['fullName'],
            email: data['email'],
            dateOfBirth: DateTime.parse(data['dateOfBirth']),
            gender: data['gender'],
            profilePicture: data['profilePicture'],
          );
          _tempProfile = _profile;
          await _saveUserDataToPreferences();
          print('User data fetched from Firestore: $_profile');
        }
      }
    } catch (e) {
      _error = e.toString();
      print('Error fetching user data from Firestore: $_error');
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

  Future<void> updateProfilePicture(String url) async {
    try {
      _setLoading(true);
      _tempProfile = _tempProfile.copyWith(profilePicture: url);
      notifyListeners();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveImageToLocalStorage(File image) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String fileName = path.basename(image.path);
      final File localFile = File(path.join(appDocPath, fileName));

      await localFile.writeAsBytes(await image.readAsBytes());

      if (await localFile.exists()) {
        _tempProfile = _tempProfile.copyWith(profilePicture: localFile.path);
        notifyListeners();
        _error = null;
      } else {
        _error = 'File not found';
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<File?> getProfilePicture() async {
    final profilePictureUrl = _profile.profilePicture;
    if (profilePictureUrl.isEmpty) {
      return null;
    }

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final String fileName = path.basename(profilePictureUrl);
    final File localFile = File(path.join(appDocPath, fileName));

    if (await localFile.exists()) {
      return localFile;
    } else {
      // Fetch the image from the URL
      final response = await http.get(Uri.parse(profilePictureUrl));
      await localFile.writeAsBytes(response.bodyBytes);
      return localFile;
    }
  }
}
