import 'package:flutter/material.dart';

import 'forgot_checkbox.dart';

class Mockrobot extends StatelessWidget {
  const Mockrobot({super.key});

  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Image.asset('assets/imgs/robot.png', width: 300),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
          child: CheckboxWidget(),
        ),
      ],
    );
  }
}
