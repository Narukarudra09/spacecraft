import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/screens/settings_screen.dart';

import '../provider/auth_provider.dart';
import '../widget/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings, color: Color(0xFFF5F5DC)),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: ListView(
        children: [
          Consumer<AuthProvider>(
            builder: (context, userProvider, _) => ProfileCard(
              name: userProvider.profile.fullName,
              email: userProvider.profile.email,
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 17, 24, 31),
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
