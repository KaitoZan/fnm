import 'package:flutter/material.dart';

import 'editpro_bt.dart';
import 'logout_bt.dart';

class BottomBt extends StatelessWidget {
  const BottomBt({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(children: [Editprobt(), SizedBox(height: 15), Logoutbt()]),
    );
  }
}
