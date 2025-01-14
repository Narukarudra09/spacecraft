import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoFav extends StatelessWidget {
  bool isEmpty;

  NoFav({super.key, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
              "https://lottie.host/fcd4330d-3034-4c98-b908-52630eac8d0f/vrY5OElx2C.json",
              width: 200,
              height: 200),
          const Text(
            "No favorite",
            style: TextStyle(fontSize: 28, color: Color(0xFFF5F5DC)),
          )
        ],
      ),
    );
  }
}
