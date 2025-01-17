import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';
import 'package:spacecraft/widget/general_settings.dart';

import '../widget/setting_profile_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
          GeneralSettings()
        ],
      ),
    );
  }
}
