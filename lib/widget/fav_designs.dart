import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/room_card.dart';

import '../provider/kitchen_provider.dart';
import '../provider/room_provider.dart';
import 'kitchen_card.dart';

class FavDesigns extends StatelessWidget {
  const FavDesigns({super.key});

  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider = Provider.of<RoomProvider>(context);
    KitchenProvider kitchenProvider = Provider.of<KitchenProvider>(context);

    return ListView(
      children: [
        if (roomProvider.favorites.isNotEmpty)
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
        if (kitchenProvider.favorites.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
            child: Text(
              "Kitchen",
              style: GoogleFonts.montserrat(
                  color: Color(0xFFF5F5DC), fontSize: 18),
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
