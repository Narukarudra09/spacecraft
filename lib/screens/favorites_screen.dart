import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/fav_designs.dart';
import 'package:spacecraft/widget/no_fav.dart';

import '../provider/kitchen_provider.dart';
import '../provider/room_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider = Provider.of<RoomProvider>(context);
    KitchenProvider kitchenProvider = Provider.of<KitchenProvider>(context);

    bool isEmpty =
        roomProvider.favorites.isEmpty && kitchenProvider.favorites.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: isEmpty ? NoFav(isEmpty: isEmpty) : const FavDesigns(),
    );
  }
}
