class OnboardContent {
  String image;
  String title;
  String text;

  OnboardContent(this.image, this.title, this.text);
}

List<OnboardContent> content = [
  OnboardContent(
    "assets/slider/slide1.png",
    "Explore Our Creations",
    "Dive into our collection of room designs and get inspired",
  ),
  OnboardContent(
    "assets/slider/slide2.png",
    "Discover Design Magic",
    "Browse our curated room designs and find your style",
  ),
  OnboardContent(
    "assets/slider/slide3.png",
    """Unveil Your Dream Space""",
    "Check out our innovative designs and transform your ideas",
  )
];
