import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/kitchen_provider.dart';
import '../widget/kitchen_card.dart';

class AllKitchenDesigns extends StatelessWidget {
  const AllKitchenDesigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All kitchen designs')),
      body: ListView(
        children: [
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
            child: const Text(
              "Kitchen",
              style: TextStyle(
                  color: Color(0xFFF5F5DC),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<KitchenProvider>(
            builder: (context, provider, _) => GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 16,
              ),
              itemCount: provider.kitchen.length,
              itemBuilder: (context, index) =>
                  KitchenCard(kitchen: provider.kitchen[index]),
            ),
          ),
        ],
      ),
    );
  }
}
