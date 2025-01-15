import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacecraft/screens/main_screen.dart';

import '../models/profile.dart';
import '../provider/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/onboarding_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    final auth = firebase_auth.FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        },
      );
    } else if (user != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        final profile = Profile(
          fullName: data['fullName'],
          email: data['email'],
          dateOfBirth: DateTime.parse(data['dateOfBirth']),
          gender: data['gender'],
          profilePicture: data['profilePicture'],
        );
        authProvider.updateProfile(profile);

        Timer(
          const Duration(seconds: 2),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        );
      } else {
        Timer(
          const Duration(seconds: 2),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        );
      }
    } else {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      );
    }

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
  }
}
