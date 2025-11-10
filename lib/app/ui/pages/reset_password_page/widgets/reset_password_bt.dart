// lib/app/ui/pages/reset_password_page/widgets/reset_password_bt.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reset_password_controller.dart';

class ResetPasswordBt extends StatelessWidget {
  ResetPasswordBt({super.key});
  final ResetPasswordController controller = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // --- ใช้ Obx ครอบปุ่ม ---
          child: Obx(() => ElevatedButton(
            // --- ผูก onPressed กับ isLoading ---
            onPressed: controller.isLoading.value ? null : controller.fetchReset,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // <<<--- เพิ่ม const
              backgroundColor: Colors.pink.withOpacity(0.24), // <<<--- แก้ไข withValues
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            // --- แสดง Loading หรือ Text ---
            child: controller.isLoading.value
                ? const SizedBox( // <<<--- ใช้ SizedBox กำหนดขนาด
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : Text(
                    'Reset Password',
                    style: GoogleFonts.charmonman(fontSize: 24, color: Colors.white),
                  ),
          )),
        ),
      ],
    );
  }
}