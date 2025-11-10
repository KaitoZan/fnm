// lib/app/ui/pages/my_profile_page/widgets/profileimshow.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'dart:io'; // ไม่จำเป็นต้องใช้ File แล้ว

import '../../login_page/login_controller.dart';

class Profileimshow extends StatelessWidget {
  const Profileimshow({super.key});

  @override
  Widget build(BuildContext context) {
    // คำนวณขนาดและตำแหน่ง
    // หมายเหตุ: AppbarB() มี preferredSize.height = 8 * 12 = 96
    final double appBarHeight = 96.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double profileCircleSize = 100.0;
    final LoginController loginController = Get.find<LoginController>();

    // --- 1. คืนค่า Positioned เป็น Widget หลัก (ลบ Column ออก) ---
    return Positioned(
      left: 0,
      right: 0,
      // คำนวณตำแหน่ง Top
      top: statusBarHeight + appBarHeight - (profileCircleSize / 1.2),
      child: Align(
        alignment: Alignment.center,
        child: Obx(() {
          final imageUrl = loginController.userProfileImageUrl.value;
          Widget imageWidget;

          if (imageUrl.startsWith('http')) {
            // --- ถ้าเป็น URL จาก Supabase ---
            imageWidget = Image.network(
              imageUrl,
              fit: BoxFit.cover,
              // เพิ่ม loadingBuilder และ errorBuilder
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              },
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/ics/person.png', fit: BoxFit.cover), // รูป Default
            );
          } else if (imageUrl.startsWith('assets/')) {
             // --- ถ้าเป็น Asset (ค่าเริ่มต้น) ---
             imageWidget = Image.asset(imageUrl, fit: BoxFit.cover);
          } else {
             // --- กรณีอื่นๆ (ค่าว่าง หรือ Path ผิดพลาด) ---
             imageWidget = Image.asset('assets/ics/person.png', fit: BoxFit.cover); // รูป Default
          }

          // --- Container แสดงผลรูป Avatar (เหมือนเดิม) ---
          return Container(
            width: profileCircleSize,
            height: profileCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(child: imageWidget),
          );
        }),
      ),
    );

  }
}