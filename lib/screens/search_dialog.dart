import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kitchen.dart';
import '../models/room.dart';
import '../provider/search_provider.dart';
import '../util/responsive_utils.dart';
import '../widget/kitchen_card.dart';
import '../widget/room_card.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<CombinedSearchProvider>(
          builder: (context, provider, _) => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context) ? 12.0 : 16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 17, 24, 31),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              cursorColor: const Color.fromARGB(255, 64, 87, 82),
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              onChanged: provider.setSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Color(0xFFF5F5DC)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFFF5F5DC)),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CombinedSearchProvider>(
        builder: (context, provider, _) => ListView(
          children: [
            if (provider.searchQuery.isEmpty) ...[
              Padding(
                padding: EdgeInsets.all(
                    ResponsiveUtils.isMobile(context) ? 12.0 : 16.0),
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: const Color(0xFFF5F5DC),
                    fontSize: ResponsiveUtils.isMobile(context) ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.isMobile(context) ? 8.0 : 16.0),
                itemCount: provider.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = provider.filteredItems[index];
                  if (item is Room) {
                    return RoomCard(room: item);
                  } else if (item is Kitchen) {
                    return KitchenCard(kitchen: item);
                  }
                  return null;
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ResponsiveUtils.getGridCrossAxisCount(context),
                  mainAxisSpacing: ResponsiveUtils.isMobile(context) ? 12 : 16,
                  crossAxisSpacing: ResponsiveUtils.isMobile(context) ? 8 : 12,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (ResponsiveUtils.getGridCrossAxisCount(context) *
                          ResponsiveUtils.getGridItemHeight(context)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
