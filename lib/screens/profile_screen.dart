import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/search_provider.dart';
import 'package:spacecraft/screens/settings/settings_screen.dart';

import '../models/kitchen.dart';
import '../models/room.dart';
import '../provider/auth_provider.dart';
import '../widget/kitchen_detailed_page.dart';
import '../widget/profile_card.dart';
import '../widget/room_detailed_page.dart';
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
              Consumer<CombinedSearchProvider>(
                builder: (context, provider, _) => GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.filteredItems[index];
                    return GestureDetector(
                      onTap: () {
                        if (item is Room) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RoomDetailScreen(room: item),
                            ),
                          );
                        } else if (item is Kitchen) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  KitchenDetailScreen(kitchen: item),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item is Room ? 'Room' : 'Kitchen',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                ),
              ),
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
