// lib/app/ui/pages/login_page/widgets/login_bt.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login_controller.dart';

class LoginBt extends StatelessWidget {
  LoginBt({super.key});
  // หา Controller
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // ใช้ Obx เพื่อ re-render ตาม isLoading
          child: Obx(() => ElevatedButton(
            // ถ้า isLoading.value เป็น true ให้ onPressed เป็น null (ปุ่ม disable)
            onPressed: controller.isLoading.value ? null : controller.fetchLogin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // ขนาดปุ่ม
              // --- ใช้ withOpacity แทน withValues ---
              backgroundColor: Colors.pink.withOpacity(0.24), // สีพื้นหลัง (8 * 0.03 = 0.24)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // ขอบมน
              ),
            ),
             // แสดง Loading Indicator หรือ Text ตาม isLoading.value
            child: controller.isLoading.value
                ? const SizedBox( // ใช้ SizedBox กำหนดขนาด Indicator
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : Text(
                    'Login', // ข้อความบนปุ่ม
                    style: GoogleFonts.charmonman(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
          )),
        ),
      ],
    );
  }
}