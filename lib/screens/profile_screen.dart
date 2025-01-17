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
  bool _isPicturesSelected = true;

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
          /*Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 17, 24, 31),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPicturesSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _isPicturesSelected
                                ? Colors.transparent
                                : const Color.fromARGB(255, 64, 87, 82)
                                    .withOpacity(0.5),
                          ),
                          child: Icon(
                              _isPicturesSelected
                                  ? Icons.table_chart
                                  : Icons.table_chart_outlined,
                              color: const Color(0xFFF5F5DC)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPicturesSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _isPicturesSelected
                                ? const Color.fromARGB(255, 64, 87, 82)
                                    .withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.video_library,
                              color: const Color(0xFFF5F5DC)),
                        ),
                      ),
                    ]),
              ))*/
        ],
      ),
    );
  }
}
