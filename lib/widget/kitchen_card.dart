import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/kitchen.dart';
import '../provider/kitchen_provider.dart';
import 'kitchen_detailed_page.dart';

class KitchenCard extends StatelessWidget {
  final Kitchen kitchen;

  const KitchenCard({super.key, required this.kitchen});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF5F5DC),
        title: Text(
          'Delete ${kitchen.name}?',
          style: GoogleFonts.montserrat(color: Color(0xFF333333)),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.montserrat(color: Color(0xFF333333)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Color(0xFF333333)),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<KitchenProvider>(context, listen: false)
                  .deleteKitchen(kitchen.id);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.montserrat(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KitchenDetailScreen(kitchen: kitchen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () => _navigateToDetail(context),
        child: SizedBox(
          width: 190,
          height: 220, // Fixed aspect ratio
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          kitchen.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 8,
                        child: Row(
                          children: [
                            Consumer<KitchenProvider>(
                              builder: (context, provider, _) => IconButton(
                                icon: Icon(
                                  kitchen.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    provider.toggleFavorite(kitchen.id),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => _showDeleteConfirmation(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            kitchen.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '4.5',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
