import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/room.dart';

class RoomDetailScreen extends StatelessWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          room.name,
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 17, 24, 31),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              room.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.specification,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  // Add more room details here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
