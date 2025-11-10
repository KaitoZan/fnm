// lib/app/ui/pages/forgot_password_page/widgets/forgot_sent_bt.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forgot_password_controller.dart';

class ForgotSentBt extends StatelessWidget {
  ForgotSentBt({super.key});
  // --- หา Controller หลัก ---
  final ForgotPasswordController controller = Get.find<ForgotPasswordController>();
  // --- ไม่จำเป็นต้องหา CheckboxController ที่นี่แล้ว ---
  // final CheckboxController checkboxController = Get.find<CheckboxController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // --- ใช้ Obx ครอบปุ่มเพื่อ disable ตอน Loading ---
          child: Obx(() => ElevatedButton(
            // --- เรียก controller.fetchForgotPassword() โดยไม่มี parameter ---
            onPressed: controller.isLoading.value ? null : controller.fetchForgotPassword,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.pink.withOpacity(0.24), // แก้ไข withValues
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            // --- แสดง Loading หรือ Text ---
            child: controller.isLoading.value
                ? const SizedBox( // ใช้ SizedBox กำหนดขนาด Indicator
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : Text(
                    'Sent',
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