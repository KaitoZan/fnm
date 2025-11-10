import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircularProgressIndicator(color: Colors.white, strokeWidth: 6),
        SizedBox(height: 8 *15),
      ],
    );
  }
}
