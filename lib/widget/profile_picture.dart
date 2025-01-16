import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile picture"),
        ),
        body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
          final profile = authProvider.profile;
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: FileImage(File(profile.profilePicture)),
              )),
              width: MediaQuery.of(context).size.width,
            ),
          );
        }));
  }
}
