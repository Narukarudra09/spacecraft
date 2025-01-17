import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/settings_provider.dart';
import '../screens/about_screen.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'General settings',
                    style: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Consumer<SettingsProvider>(
                  builder: (context, settingsProvider, _) => ListTile(
                    tileColor: const Color.fromARGB(255, 17, 24, 31),
                    shape: const StadiumBorder(),
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
                /*const SizedBox(
                height: 8,
              ),*/
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFFF5F5DC)),
                  tileColor: const Color.fromARGB(255, 17, 24, 31),
                  shape: const StadiumBorder(),
                  title: Text(
                    'About us',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFF5F5DC),
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen())),
                ),
                /*Consumer<SettingsProvider>(
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
                      leading:
                          const Icon(Icons.add_box, color: Color(0xFFF5F5DC)),
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
                ],*/
              ]),
        ),
        const Divider(
          thickness: 2,
          color: Color.fromARGB(255, 17, 24, 31),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF5F5DC)),
            tileColor: const Color.fromARGB(255, 17, 24, 31),
            shape: const StadiumBorder(),
            title: Text(
              'Log out',
              style: GoogleFonts.montserrat(
                color: const Color(0xFFF5F5DC),
              ),
            ),
            onTap: () => AuthProvider().logout(context),
          ),
        ),
      ],
    );
  }
}
