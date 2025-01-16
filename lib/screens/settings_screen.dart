import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';

import '../provider/settings_provider.dart';
import '../widget/setting_profile_card.dart';
import 'add_room_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Consumer<AuthProvider>(
            builder: (context, userProvider, _) => SettingProfileCard(
              name: userProvider.profile.fullName,
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(255, 17, 24, 31),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Color(
                  0xFFF5F5DC,
                ),
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
          const Divider(
            thickness: 2,
            color: Color.fromARGB(255, 17, 24, 31),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF5F5DC)),
            title: Text(
              'Log out',
              style: GoogleFonts.montserrat(
                color: const Color(0xFFF5F5DC),
              ),
            ),
            onTap: () => AuthProvider().logout(context),
          ),
        ],
      ),
    );
  }
}
