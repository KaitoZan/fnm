// lib/app/ui/pages/my_profile_page/widgets/profileimshow.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// <<<--- [TASK 12.3 - เพิ่ม] Import
import 'package:cached_network_image/cached_network_image.dart';

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
            // <<<--- [TASK 12.3 - เริ่มแก้ไข] ---
            // (ลบ Image.network)
            // imageWidget = Image.network(
            //   imageUrl,
            //   fit: BoxFit.cover,
            //   loadingBuilder: (context, child, loadingProgress) {
            //     ...
            //   },
            //   errorBuilder: (context, error, stackTrace) =>
            //       Image.asset('assets/ics/person.png', fit: BoxFit.cover), // รูป Default
            // );
            
            // (ใช้ CachedNetworkImage แทน)
            imageWidget = CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              errorWidget: (context, url, error) => Image.asset('assets/ics/person.png', fit: BoxFit.cover),
            );
            // <<<--- [TASK 12.3 - สิ้นสุดการแก้ไข] ---

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