import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/room_card.dart';

import '../provider/kitchen_provider.dart';
import '../provider/room_provider.dart';
import 'kitchen_card.dart';

class FavDesigns extends StatefulWidget {
  const FavDesigns({super.key});

  @override
  _FavDesignsState createState() => _FavDesignsState();
}

class _FavDesignsState extends State<FavDesigns> {
  @override
  void initState() {
    super.initState();
    // Load favorites from the database when the widget is initialized
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final kitchenProvider =
        Provider.of<KitchenProvider>(context, listen: false);

    roomProvider.loadFavoritesFromDatabase();
    kitchenProvider.loadFavoritesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (Provider.of<RoomProvider>(context).favorites.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
            child: Text(
              "Room",
              style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC), fontSize: 18),
            ),
          ),
        Consumer<RoomProvider>(
          builder: (context, provider, _) => GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) =>
                RoomCard(room: provider.favorites[index]),
          ),
        ),
        if (Provider.of<KitchenProvider>(context).favorites.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
            child: Text(
              "Kitchen",
              style: GoogleFonts.montserrat(
                  color: const Color(0xFFF5F5DC), fontSize: 18),
            ),
          ),
        Consumer<KitchenProvider>(
          builder: (context, provider, _) => GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) =>
                KitchenCard(kitchen: provider.favorites[index]),
          ),
        ),
      ],
    );
  }
}
