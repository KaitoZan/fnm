// lib/app/ui/pages/register_page/widgets/register_image_profile_insert.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../register_controller.dart';

class RegisterImageProfileInsert extends StatelessWidget {
  // <<<--- เพิ่ม const constructor
  const RegisterImageProfileInsert({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();
    return Align(
      alignment: Alignment.center,
      child: GestureDetector( // ทำให้กดเลือกรูปได้
        onTap: () => controller.pickProfileImage(), // เรียกฟังก์ชันเลือกรูป
        child: Obx( // ใช้ Obx เพื่อให้ UI อัปเดตตาม State
          () {
            final imagePath = controller.selectedProfileImagePath; // ดึง Path จาก Controller
            ImageProvider? backgroundImage; // <<<--- 1. ประกาศเป็น Nullable

            // --- 2. ตรวจสอบว่า Path ไม่ใช่ค่าว่าง และ ไฟล์มีอยู่จริง ---
            if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
              backgroundImage = FileImage(File(imagePath)); // ถ้ามี Path ใช้ FileImage
            }
            // --- 3. ถ้าไม่มี Path ให้ backgroundImage เป็น null (จะไม่แสดง BackgroundImage) ---
            // else {
            //   backgroundImage = const AssetImage(''); // <<<--- ลบบรรทัดนี้
            // }

            return CircleAvatar(
              radius: 44, // ขนาด Avatar
              backgroundColor: Colors.white.withOpacity(0.1), // <<<--- แก้ไข withValues
              backgroundImage: backgroundImage, // <<<--- ใช้ backgroundImage ที่เป็น Nullable
              // --- 4. แสดงไอคอนกล้อง *เฉพาะเมื่อ* ไม่มีรูป (backgroundImage เป็น null) ---
              child: backgroundImage == null
                  ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]) // แสดงไอคอน
                  : null, // ไม่แสดง child ถ้ามีรูปแล้ว
            );
          }
        ),
      ),
    );
  }
}