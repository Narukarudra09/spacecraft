import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/screens/settings_screen.dart';

import '../provider/auth_provider.dart';
import '../widget/profile_card.dart';
import 'add_room_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    // Simulate fetching uploaded content
    _fetchUploadedContent();
  }

  Future<void> _fetchUploadedContent() async {
    // Simulate a delay for fetching content
    await Future.delayed(const Duration(seconds: 2));

    // Simulate fetched content
    setState(() {
      _pictures = List.generate(10, (index) => 'Picture $index');
    });
  }

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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = authProvider.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data available.'));
          }

          return ListView(
            children: [
              ProfileCard(
                name: profile.fullName,
                email: profile.email,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 17, 24, 31),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 64, 87, 82)
                                .withOpacity(0.5),
                          ),
                          child: const Icon(Icons.table_chart,
                              color: Color(0xFFF5F5DC)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                ),
                itemCount: _pictures.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(_pictures[index])),
                  );
                },
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 17, 24, 31),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddRoomDialog();
          }));
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Color(0xFFF5F5DC),
          ),
        ),
      ),
    );
  }
}
