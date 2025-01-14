import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderIndicator extends StatefulWidget {
  const SliderIndicator({super.key});

  @override
  State<SliderIndicator> createState() => _SliderIndicatorState();
}

int _current = 0;
PageController control = PageController(keepPage: true);
List<String> image = [
  "assets/slider/slide1.png",
  "assets/slider/slide2.png",
  "assets/slider/slide3.png",
];

class _SliderIndicatorState extends State<SliderIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: image
              .map((item) => Container(
                    child: Center(
                        child: Image.asset(
                      item.toString(),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 400,
                    )),
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: image.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => CarouselSlider.builder(
                itemCount: image.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.network(
                    image[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1.0,
                  onPageChanged: (int index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              child: Container(
                width: 8.0,
                height: 16.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? Color.fromARGB(255, 17, 24, 31)
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
