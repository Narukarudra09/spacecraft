import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/onboard_content.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSkip() {
    _controller.jumpToPage(content.length);
  }

  void _onNext() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 64, 87, 82),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 68),
            _buildPageView(),
            const Expanded(child: SizedBox(height: 48)),
            _isLastPage ? _buildGetStartedButton() : _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Stack(
      alignment: const Alignment(0, 0.233),
      children: [
        SizedBox(
          width: double.infinity,
          height: 532,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == content.length - 1;
              });
            },
            controller: _controller,
            itemCount: content.length,
            itemBuilder: (context, index) {
              return _buildPageContent(index);
            },
          ),
        ),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageContent(int index) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 293,
          child: Image.asset(content[index].image),
        ),
        const SizedBox(height: 83),
        SizedBox(
          width: 307,
          height: 88,
          child: Text(
            content[index].title,
            style: GoogleFonts.montserrat(
              color: Color.fromARGB(255, 17, 24, 31),
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 308,
          height: 48,
          child: Text(
            content[index].text,
            style: GoogleFonts.montserrat(
              color: Color(0xFFF5F5DC),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _controller,
      count: content.length,
      effect: const ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        spacing: 12,
        dotColor: Color.fromARGB(255, 209, 213, 219),
        activeDotColor: Color.fromARGB(255, 17, 24, 31),
      ),
      onDotClicked: (index) {
        _controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }

  Widget _buildGetStartedButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 116),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 17, 24, 31),
              ),
              child: Center(
                child: Text(
                  "Get started",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F5DC),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 66),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 116),
          child: InkWell(
            onTap: _onNext,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 17, 24, 31),
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5F5DC),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _onSkip,
          child: SizedBox(
            height: 24,
            child: Text(
              "Skip",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Color(0xFFF5F5DC),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
