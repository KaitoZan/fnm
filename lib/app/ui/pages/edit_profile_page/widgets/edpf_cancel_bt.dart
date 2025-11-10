import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EdpfCancelBt extends StatelessWidget {
  const EdpfCancelBt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'ยกเลิก',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}