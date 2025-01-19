import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/kitchen_provider.dart';
import '../provider/room_provider.dart';
import '../util/slider_indicator.dart';
import '../widget/kitchen_card.dart';
import '../widget/room_card.dart';
import 'all_kitchen_designs.dart';
import 'all_room_designs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RoomProvider provider = Provider.of<RoomProvider>(context);
    KitchenProvider kitchenProvider = Provider.of<KitchenProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Space Craft")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SliderIndicator(),
            if (provider.rooms.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Room",
                      style: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllRoomDesigns()));
                        },
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                        color: const Color(0xFFF5F5DC))
                  ],
                ),
              ),
            SizedBox(
              height: 220,
              child: Consumer<RoomProvider>(
                builder: (context, provider, _) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return RoomCard(room: provider.rooms[index]);
                    }),
              ),
            ),
            if (kitchenProvider.kitchen.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kitchen",
                      style: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllKitchenDesigns()));
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined),
                      color: const Color(0xFFF5F5DC),
                    )
                  ],
                ),
              ),
            SizedBox(
              height: 220,
              child: Consumer<KitchenProvider>(
                builder: (context, provider, _) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return KitchenCard(kitchen: provider.kitchen[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
