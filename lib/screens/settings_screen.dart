import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';
import 'package:spacecraft/screens/profile_screen.dart';

import '../provider/settings_provider.dart';
import '../provider/theme_provider.dart';
import '../widget/profile_picture.dart';
import 'add_room_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
              onPressed: () {
                AuthProvider().logout(context);
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: ListView(
        children: [
          Consumer<AuthProvider>(
            builder: (context, userProvider, _) => _ProfileCard(
              name: userProvider.profile.fullName,
              email: userProvider.profile.email,
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 17, 24, 31),
            thickness: 2,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => ListTile(
              leading: const Icon(
                Icons.person,
                color: Color(0xFFF5F5DC),
              ),
              title: Text(
                "Profile",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Color(0xFFF5F5DC),
              ),
              title: Text(
                'Notifications',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC),
                ),
              ),
              trailing: Switch(
                activeColor: const Color(0xFFF5F5DC),
                value: settingsProvider.notificationsEnabled,
                onChanged: (_) => settingsProvider.toggleNotifications(),
              ),
            ),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Color(0xFFF5F5DC),
              ),
              title: Text(
                'Toggle Admin Status',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC),
                ),
              ),
              trailing: Switch(
                activeColor: const Color(0xFFF5F5DC),
                value: settingsProvider.isAdmin,
                onChanged: (_) => settingsProvider.toggleAdmin(),
              ),
            ),
          ),
          if (context.watch<SettingsProvider>().isAdmin) ...[
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Admin Panel',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 21, 27, 31),
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.add_box, color: Color(0xFFF5F5DC)),
                title: Text(
                  'Add New Room',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFF5F5DC),
                  ),
                ),
                onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddRoomDialog();
                    }))),
          ],
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                    color: Color(0xFFF5F5DC)),
              ),
              Text(
                email,
                style: GoogleFonts.montserrat(color: Color(0xFFF5F5DC)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
