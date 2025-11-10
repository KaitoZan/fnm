// lib/app/ui/pages/login_page/widgets/login_path_bt.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart'; // <<<--- Import AppRoutes
// import 'package:food_near_me_app/app/ui/pages/forgot_password_page/forgot_password_page.dart'; // ไม่ต้อง Import Page
// import 'package:food_near_me_app/app/ui/pages/register_page/register_page.dart'; // ไม่ต้อง Import Page
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import '../login_controller.dart'; // ไม่ได้ใช้ LoginController ใน Widget นี้

class LoginPathBt extends StatelessWidget {
  // <<<--- เพิ่ม const constructor
  const LoginPathBt({super.key});
  // final LoginController controller = Get.find<LoginController>(); // ไม่จำเป็นต้องใช้

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดปุ่มชิดซ้าย-ขวา
          children: [
            // --- ปุ่ม Register ---
            TextButton(
              onPressed: () {
                // --- ใช้ Get.toNamed ---
                Get.toNamed(AppRoutes.REGISTER); // <<<--- ไปหน้า Register โดยใช้ชื่อ Route
              },
              child: Text(
                "Register", // ข้อความปุ่ม
                style: GoogleFonts.charmonman(
                  color: Colors.amber[200], // สีตัวอักษร
                  fontSize: 15,
                ),
              ),
            ),
            // --- ปุ่ม Forgot password? ---
            TextButton(
              onPressed: () {
                // --- ใช้ Get.toNamed ---
                Get.toNamed(AppRoutes.FORGOTPASSWORD); // <<<--- ไปหน้า Forgot Password โดยใช้ชื่อ Route
              },
              child: Text(
                "Forgot password?", // ข้อความปุ่ม
                style: GoogleFonts.charmonman(
                  color: Colors.amber[200], // สีตัวอักษร
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}