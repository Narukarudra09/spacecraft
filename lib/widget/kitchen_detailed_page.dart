import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/kitchen.dart';

class KitchenDetailScreen extends StatelessWidget {
  final Kitchen kitchen;

  const KitchenDetailScreen({super.key, required this.kitchen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kitchen.name),
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
              kitchen.imageUrl,
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
                    kitchen.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5DC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kitchen.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
