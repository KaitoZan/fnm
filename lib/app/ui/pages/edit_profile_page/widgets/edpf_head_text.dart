import 'package:flutter/material.dart';

class EdpfHeadText extends StatelessWidget {
  const EdpfHeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}