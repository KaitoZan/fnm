import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ScrollToTopButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: onPressed,
      mini: false,
      backgroundColor: Colors.blue[300],
      heroTag: null,
      child: const Icon(
        Icons.keyboard_double_arrow_up_sharp,
        color: Colors.lightGreenAccent,
        size: 35,
      ),
    );
  }
}
