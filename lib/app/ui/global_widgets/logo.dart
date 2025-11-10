import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset('assets/imgs/logo.png', width: width),
        ),
       
      ],
    );
  }
}
