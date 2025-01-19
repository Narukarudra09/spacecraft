import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/screens/settings/feedback_screen.dart';

import '../provider/auth_provider.dart';
import '../provider/settings_provider.dart';
import '../screens/settings/about_screen.dart';

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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFFF5F5DC)),
                tileColor: const Color.fromARGB(255, 17, 24, 31),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text(
                  'About us',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFF5F5DC),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFF5F5DC),
                ),
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AboutScreen(),
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
                ),
              ),
              ListTile(
                leading: const Icon(Icons.feedback_rounded,
                    color: Color(0xFFF5F5DC)),
                tileColor: const Color.fromARGB(255, 17, 24, 31),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text(
                  'Feedback',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFF5F5DC),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFF5F5DC),
                ),
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const FeedbackScreen(),
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
                ),
              ),
            ],
          ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
