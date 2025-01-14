import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/screens/search_dialog.dart';

import '../models/kitchen.dart';
import '../models/room.dart';
import '../provider/search_provider.dart';
import '../widget/kitchen_detailed_page.dart';
import '../widget/room_detailed_page.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CombinedSearchProvider>(
          builder: (context, provider, _) => Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 17, 24, 31),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SearchDialog(),
                ));
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFFF5F5DC)),
                icon: Icon(Icons.search, color: Color(0xFFF5F5DC)),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CombinedSearchProvider>(
        builder: (context, provider, _) => GridView.builder(
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
                      builder: (_) => KitchenDetailScreen(kitchen: item),
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
                        style: const TextStyle(
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
              crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
        ),
      ),
    );
  }
}
