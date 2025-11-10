// lib/app/ui/pages/reset_password_page/reset_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <<<--- 1. Import Supabase

import '../../../routes/app_routes.dart';
// import '../forgot_password_page/forgot_password_controller.dart'; // <<<--- 2. ไม่จำเป็นต้องใช้
// import '../login_page/login_controller.dart'; // <<<--- 2. ไม่จำเป็นต้องใช้

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _obscureText = true.obs;
  final _obscureText2 = true.obs;

  get obscureText => _obscureText.value;
  get obscureText2 => _obscureText2.value;

  set obscureText(value) => _obscureText.value = value;
  set obscureText2(value) => _obscureText2.value = value;

  final supabase = Supabase.instance.client; // <<<--- 3. เพิ่ม Supabase Client
  final RxBool isLoading = false.obs; // <<<--- 4. เพิ่ม isLoading State

  // --- 5. ลบ Controller ที่ไม่ใช้ออก ---
  // final LoginController _loginController = Get.find<LoginController>();
  // final ForgotPasswordController _forgotpassController = Get.find<ForgotPasswordController>();

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // --- 6. แก้ไขฟังก์ชันรีเซ็ตรหัสผ่าน ---
  void fetchReset() async { // ทำให้เป็น async
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true; // <<<--- เริ่ม Loading

    // --- ตรวจสอบ Input เหมือนเดิม ---
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'กรุณากรอกข้อมูลให้ครบถ้วน');
      isLoading.value = false; return; // <<<--- หยุด Loading
    }
    if (passwordController.text.length < 6) {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัวอักษร');
      isLoading.value = false; return; // <<<--- หยุด Loading
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'รหัสผ่านไม่ตรงกัน');
      isLoading.value = false; return; // <<<--- หยุด Loading
    }

    try {
      // --- 8. เรียก Supabase Auth API เพื่ออัปเดตรหัสผ่าน ---
      await supabase.auth.updateUser(
        UserAttributes(
          password: passwordController.text,
        ),
      );

      // --- 9. แจ้งสำเร็จและไปหน้า Login ---
      passwordController.clear();
      confirmPasswordController.clear();
      isLoading.value = false; // <<<--- หยุด Loading

      Get.closeCurrentSnackbar(); // <<<--- FIX: ปิด Snackbar เก่า
      Get.snackbar(
        'สำเร็จ',
        'รีเซ็ตรหัสผ่านสำเร็จ! กรุณาเข้าสู่ระบบด้วยรหัสผ่านใหม่',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // ใช้ offAllNamed เพื่อเคลียร์ Stack และไปหน้า Login
      Get.offAllNamed(AppRoutes.LOGIN);

    } on AuthException catch (e) {
      // --- 10. จัดการ Error จาก Supabase (เช่น Token หมดอายุ) ---
      isLoading.value = false; // <<<--- หยุด Loading
      Get.closeCurrentSnackbar(); // <<<--- FIX
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.message, // แสดงข้อความ Error จาก Supabase
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      // --- 11. จัดการ Error อื่นๆ ---
      isLoading.value = false; // <<<--- หยุด Loading
      Get.closeCurrentSnackbar(); // <<<--- FIX
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถรีเซ็ตรหัสผ่านได้: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}