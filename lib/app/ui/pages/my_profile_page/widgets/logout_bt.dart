import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../login_page/login_controller.dart';
// import '../../login_page/login_page.dart'; // (ลบออก)

class Logoutbt extends StatelessWidget {
  const Logoutbt({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    return Column(
      children: [
        TextButton(
          // --- [แก้ไข] ---
          onPressed: () async { // <<<--- เพิ่ม async
            await loginController.logout(); // <<<--- เพิ่ม await
            Get.offAllNamed(AppRoutes.LOGIN); // <<<--- (คงเดิม)
          },
          // --- [สิ้นสุดการแก้ไข] ---
          child: Text(
            'ออกจากระบบ',
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