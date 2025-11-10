// lib/app/ui/pages/forgot_password_page/forgot_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

import '../../../routes/app_routes.dart';

// ... (omitted CheckboxController class) ...

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // --- 5. แก้ไขฟังก์ชันส่งคำขอ Magic Link/OTP และนำทางไปหน้า OTP ---
  void fetchForgotPassword() async { 
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;

    // --- ตรวจสอบ Input เหมือนเดิม ---
    if (emailController.text.trim().isEmpty) {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'กรุณากรอกอีเมล');
      isLoading.value = false; return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'กรุณากรอกอีเมลให้ถูกต้อง');
      isLoading.value = false; return;
    }

    try {
      // 1. ส่ง Magic Link (หรือ OTP) ผ่าน Email
      // NOTE: Supabase จะส่งลิงก์ยืนยันไปที่อีเมล แต่เราจะบอก User ว่าส่ง OTP ไปแล้ว
      // หากคุณตั้งค่า Supabase ให้ส่ง OTP 6 หลัก, คุณจะต้องใช้ signInWithOtp (Email OTP) แทน
      
      // เราใช้ resetPasswordForEmail (เพื่อรีเซ็ต) แล้วบังคับให้ไปหน้า OTP
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        // redirectTo: 'myapp://reset-password', // Supabase จะจัดการลิงก์นี้
      );


      // 2. แจ้งสำเร็จและนำทางไปหน้า OTP/ยืนยันรหัส
      // Note: ใน Flow จริง User ต้องไปเช็คอีเมลเพื่อรับรหัส
      
      isLoading.value = false; // <<<--- หยุด Loading

      Get.closeCurrentSnackbar();
      Get.snackbar(
        'สำเร็จ',
        'ระบบได้ส่งรหัสยืนยันไปยังอีเมลของคุณแล้ว (โปรดตรวจสอบกล่องจดหมาย)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // --- FIX: นำทางไปหน้า OTP ทันทีหลังส่งคำขอ ---
      // Get.offAllNamed(AppRoutes.OTP); 
      Get.toNamed(AppRoutes.OTP);

    } on AuthException catch (e) {
      // --- จัดการ Error จาก Supabase (เช่น ไม่พบอีเมล) ---
      isLoading.value = false;
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      // --- จัดการ Error อื่นๆ ---
      isLoading.value = false;
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถส่งคำขอรีเซ็ตรหัสผ่านได้: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

// --- CheckboxController (แยกคลาสไว้) ---
class CheckboxController extends GetxController {
  final RxBool isChecked = false.obs;
  void toggleCheckbox(bool? newValue) {
    if (newValue != null) {
      isChecked.value = newValue;
    }
  }
}