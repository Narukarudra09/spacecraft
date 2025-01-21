import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacecraft/provider/auth_provider.dart';
import 'package:spacecraft/screens/main_screen.dart';

import '../provider/kitchen_provider.dart';
import '../provider/room_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';

class SplashServices {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  void isLogin(BuildContext context) async {
    final user = _auth.currentUser;

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
      await Provider.of<AuthProvider>(context, listen: false)
          .loadUserDataFromPreferences();
      await Provider.of<RoomProvider>(context, listen: false)
          .loadFavoritesFromDatabase();
      await Provider.of<KitchenProvider>(context, listen: false)
          .loadFavoritesFromDatabase();
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

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
  }
}
