// lib/app/ui/pages/otp_page/otp_controller.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <<<--- เพิ่ม Supabase

class OtpController extends GetxController {
  final int fields;
  final List<TextEditingController> otpcontroller;
  final supabase = Supabase.instance.client; // <<<--- เพิ่ม Supabase Client

  OtpController({this.fields = 5})
    : otpcontroller = List.generate(fields, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    // --- Logic การเปลี่ยน Focus เหมือนเดิม ---
    for (int i = 0; i < otpcontroller.length; i++) {
      otpcontroller[i].addListener(() {
        if (otpcontroller[i].text.length == 1 && i < otpcontroller.length - 1) {
          if (Get.context != null) {
            FocusScope.of(Get.context!).nextFocus();
          }
        }
        else if (otpcontroller[i].text.isEmpty && i > 0) {
          if (Get.context != null) {
            FocusScope.of(Get.context!).previousFocus();
          }
        }
      });
    }
  }

  @override
  void onClose() {
    for (var controller in otpcontroller) {
      controller.dispose();
    }
    super.onClose();
  }

  String getOtpValue() {
    return otpcontroller.map((controller) => controller.text).join();
  }

  void clearOtpFields() {
    for (var controller in otpcontroller) {
      controller.clear();
    }
     if (Get.context != null) {
        FocusScope.of(Get.context!).unfocus();
     }
  }

  // --- แก้ไข verifyOtp: (จำลองการยืนยันสำเร็จ) ---
  void verifyOtp() async {
    String enteredOtp = getOtpValue();

    // --- เช็คว่ากรอกครบหรือไม่ ---
    if (enteredOtp.isEmpty || enteredOtp.length < fields) {
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'System',
        'กรุณากรอกรหัส OTP ให้ครบถ้วน',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.1), 
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    }

    // --- Note: ใน Production คุณจะต้องใช้ Logic ตรวจสอบ Token/OTP ที่นี่ ---
    // เช่น: final res = await supabase.auth.verifyOTP(token: enteredOtp, type: OtpType.email);
    
    // --- จำลอง: ถือว่ายืนยันสำเร็จและนำทาง ---
    await Future.delayed(const Duration(milliseconds: 500));
    clearOtpFields();

    Get.closeCurrentSnackbar();
    Get.snackbar(
      'System',
      'ยืนยันรหัสเรียบร้อยแล้ว กำลังไปยังหน้าตั้งรหัสผ่านใหม่...', 
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
        // นำทางไปหน้า Reset Password
        Get.toNamed(AppRoutes.RESETPASSWORD); 
    });
  }
}