import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/profile_picture.dart';

import '../provider/auth_provider.dart';
import '../screens/settings/update_profile_screen.dart';

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
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const UpdateProfileScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    final tween = Tween(begin: begin, end: end);
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    );

                    return SlideTransition(
                      position: tween.animate(curvedAnimation),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 17, 24, 31),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF5F5DC)),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFFF5F5DC)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
