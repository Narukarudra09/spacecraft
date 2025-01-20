import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/profile_picture.dart';

import '../provider/auth_provider.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const ProfileCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 17, 24, 31),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  radius: 60,
                  backgroundImage: profile.profilePicture.isEmpty
                      ? const AssetImage('assets/profile.jpeg') as ImageProvider
                      : FileImage(File(profile.profilePicture)),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5F5DC)),
              ),
              Text(
                email,
                style: GoogleFonts.montserrat(color: const Color(0xFFF5F5DC)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
