import 'package:flutter/material.dart';

class Iconperson extends StatelessWidget {
  const Iconperson({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset('assets/ics/person.png', width: 8 * 11),
        ),
      ],
    );
  }
}
