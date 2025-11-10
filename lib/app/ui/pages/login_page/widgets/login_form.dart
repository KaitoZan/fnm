// lib/app/ui/pages/login_page/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login_controller.dart'; // Import Controller หลัก

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  // หา Controller ที่ Binding สร้างไว้
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- ช่องกรอก Email ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          child: TextField(
            controller: controller.emailController, // ใช้ Controller ที่ถูกต้อง
            keyboardType: TextInputType.emailAddress, // Keyboard สำหรับ Email
            style: const TextStyle(color: Colors.white), // <<<--- เพิ่ม: สีตัวอักษรที่พิมพ์
            decoration: InputDecoration(
              hintText: 'Username or Email', // ข้อความ Hint
              hintStyle: GoogleFonts.charmonman(
                // --- คง withValues ไว้ ---
                color: Colors.white.withValues(alpha: 8 * 0.07), // สี Hint
              ),
              filled: true, // ให้มีสีพื้นหลัง
              // --- คง withValues ไว้ ---
              fillColor: Colors.white.withValues(alpha: 8 * 0.03), // สีพื้นหลังช่องกรอก
              border: OutlineInputBorder( // กรอบ (ไม่มีเส้นขอบ)
                borderRadius: BorderRadius.circular(10), // ขอบมน
                borderSide: BorderSide.none, // ไม่มีเส้นขอบ
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding ภายใน
            ),
          ),
        ),
        const SizedBox(height: 8), // <<<--- เพิ่ม const

        // --- ช่องกรอก Password ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          child: Obx( // ใช้ Obx เพื่อให้ UI อัปเดตตาม State การซ่อนรหัส
            () => TextField(
              controller: controller.passwordController, // ใช้ Controller ที่ถูกต้อง
              // --- ใช้ !isPasswordVisible.value ---
              obscureText: !controller.isPasswordVisible.value, // ซ่อน/แสดงรหัสตาม State
              style: const TextStyle(color: Colors.white), // <<<--- เพิ่ม: สีตัวอักษรที่พิมพ์
              decoration: InputDecoration(
                hintText: 'Password', // ข้อความ Hint
                hintStyle: GoogleFonts.charmonman(
                  // --- คง withValues ไว้ ---
                  color: Colors.white.withValues(alpha: 8 * 0.07), // สี Hint
                ),
                filled: true, // ให้มีสีพื้นหลัง
                // --- คง withValues ไว้ ---
                fillColor: Colors.white.withValues(alpha: 8 * 0.03), // สีพื้นหลังช่องกรอก
                suffixIcon: IconButton( // ไอคอนสำหรับกดดู/ซ่อนรหัส
                  icon: Icon(
                    // --- สลับไอคอนตาม isPasswordVisible.value ---
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off // ถ้าเห็นอยู่ ให้แสดงไอคอน "ซ่อน"
                        : Icons.visibility, // ถ้าซ่อนอยู่ ให้แสดงไอคอน "แสดง"
                    color: Colors.grey.shade300, // สีไอคอน
                  ),
                  // --- เรียกใช้ฟังก์ชัน togglePasswordVisibility ---
                  onPressed: controller.togglePasswordVisibility, // Callback เมื่อกดไอคอน
                ),
                border: OutlineInputBorder( // กรอบ (ไม่มีเส้นขอบ)
                  borderRadius: BorderRadius.circular(10), // <<<--- ปรับ Radius ให้เหมือนช่อง Email
                  borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding ภายใน
              ),
            ),
          ),
        ),
      ],
    );
  }
}