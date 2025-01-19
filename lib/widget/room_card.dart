import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/widget/room_detailed_page.dart';

import '../models/room.dart';
import '../provider/room_provider.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 21, 27, 31),
        title: Text(
          'Delete ${room.name}?',
          style: GoogleFonts.montserrat(color: Color(0xFFF5F5DC)),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.montserrat(color: Color(0xFFF5F5DC)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Color(0xFFF5F5DC)),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<RoomProvider>(context, listen: false)
                  .deleteRoom(room.id);
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
        builder: (context) => RoomDetailScreen(room: room),
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
                          room.imageUrl,
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
                            Consumer<RoomProvider>(
                              builder: (context, provider, _) => IconButton(
                                icon: Icon(
                                  room.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    provider.toggleFavorite(room.id),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFF5F5DC),
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
                            room.name,
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
