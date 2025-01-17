import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/profile_picture.dart';

import '../provider/auth_provider.dart';
import '../screens/update_profile_screen.dart';

class SettingProfileCard extends StatelessWidget {
  final String name;

  const SettingProfileCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Profile settings',
              style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 17, 24, 31),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final profile = authProvider.profile;
                      return GestureDetector(
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePicture()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: profile.profilePicture.isEmpty
                              ? const AssetImage('assets/profile.jpeg')
                                  as ImageProvider
                              : FileImage(File(profile.profilePicture)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF5F5DC)),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UpdateProfileScreen()));
                    },
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFFF5F5DC)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
