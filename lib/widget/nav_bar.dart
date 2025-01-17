import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 400;
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
            bottom: BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
            left: BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
            right: BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
          ),
          color: Color.fromARGB(255, 17, 24, 31),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 28.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                title: 'Home',
              ),
              _NavBarItem(
                icon: Icons.search,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                title: 'Search',
              ),
              _NavBarItem(
                icon: Icons.favorite,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
                title: 'Favorite',
              ),
              _NavBarItem(
                icon: Icons.person,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                title: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 64, 87, 82).withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFF5F5DC)),
            if (isSelected)
              Text(
                title,
                style: GoogleFonts.montserrat(
                    color: const Color(0xFFF5F5DC),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
