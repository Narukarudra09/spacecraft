import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About us"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: ListView(
          children: [
            Text(
              'Welcome to Spacecraft!',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'At Spacecraft, we believe that your living space should be a reflection of your personality and lifestyle. Our mission is to transform ordinary rooms into extraordinary spaces that inspire and delight. Whether you\'re looking to redesign your home, office, or any other space, Spacecraft is your ultimate destination for innovative and stylish room designs.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFF5F5DC),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'Our Story',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Founded by a team of passionate designers and tech enthusiasts, Spacecraft was born out of a love for creating beautiful and functional spaces. We understand that designing a room can be both exciting and challenging, which is why we\'ve developed an intuitive and user-friendly app to make the process enjoyable and stress-free.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFF5F5DC),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'What We Offer',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Curated Designs: Explore a vast collection of meticulously curated room designs that cater to various tastes and styles. From modern minimalist to classic elegance, we have something for everyone.\n'
              '• Customization: Personalize your space with our easy-to-use customization tools. Adjust colors, furniture, and layouts to create a room that truly feels like your own.\n'
              '• Expert Advice: Get professional tips and tricks from our team of experienced designers. Whether you need help with color schemes, furniture placement, or overall aesthetics, we\'re here to guide you.\n'
              '• Inspiration: Browse through our gallery of stunning room designs to gather inspiration for your next project. See how others have transformed their spaces and get ideas for your own.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFF5F5DC),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'Our Commitment',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'At Spacecraft, we are committed to providing you with the best tools and resources to create the perfect room design. We continuously update our app with the latest trends and features to ensure that you have everything you need to bring your vision to life.',
              style: GoogleFonts.montserrat(
                  fontSize: 16, color: const Color(0xFFF5F5DC)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'Join Our Community',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We invite you to join our growing community of design enthusiasts. Share your creations, get feedback, and connect with like-minded individuals who share your passion for beautiful spaces. Together, we can inspire each other and create amazing rooms that tell a story.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFF5F5DC),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'Get Started',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to transform your space? Download Spacecraft today and start your design journey. Whether you\'re a seasoned designer or just starting out, our app is designed to make the process fun and rewarding.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFF5F5DC),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you for choosing Spacecraft. We can\'t wait to see the incredible spaces you create!',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 21, 27, 31),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
