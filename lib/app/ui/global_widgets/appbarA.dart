// lib/app/ui/global_widgets/appbarA.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// <<<--- [TASK 12.3 - เพิ่ม] Import
import 'package:cached_network_image/cached_network_image.dart';

import '../../routes/app_routes.dart';
import '../pages/login_page/login_controller.dart';
import 'filter_ctrl.dart';

class AppbarA extends StatelessWidget implements PreferredSizeWidget {
  final String tag; // Tag สำหรับ FilterController (home, favorite, myshop)

  // ใช้ const constructor ได้ ถ้า Properties เป็น final
  const AppbarA({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    // หา Controller ภายใน build method
    final LoginController loginController = Get.find<LoginController>();
    final FilterController filterController = Get.find<FilterController>();

    return AppBar(
      backgroundColor: Colors.pink[200],
      // Title แสดง Logo
      title: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          "assets/imgs/logoHome.png",
          height: kToolbarHeight * 0.8, // ปรับความสูงตาม kToolbarHeight
          fit: BoxFit.contain,
        ),
      ),
      toolbarHeight: kToolbarHeight + 24, // ความสูง AppBar
      automaticallyImplyLeading: false, // ไม่มีปุ่ม Back อัตโนมัติ
      actions: [
        Obx(() { // ใช้ Obx เพื่อติดตามสถานะ Login
          if (loginController.isLoggedIn.value) {
            // --- ถ้า Login อยู่: แสดง PopupMenuButton พร้อม Avatar ---
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<String>(
                // --- (onSelected ... เหมือนเดิม) ---
                onSelected: (String result) async { 
                  filterController.clearSearchFocus(tag);
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 100)); 

                  if (result == 'profile') {
                    Get.toNamed(AppRoutes.MYPROFILE);
                  } else if (result == 'setting') {
                    Get.toNamed(AppRoutes.SETTING);
                  } else if (result == 'logout') {
                    await Future.delayed(const Duration(milliseconds: 50)); 
                    await loginController.logout(); 
                    Get.offAllNamed(AppRoutes.LOGIN);
                  }
                },
                // --- (itemBuilder ... เหมือนเดิม) ---
                color: Colors.pink[50], 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                offset: const Offset(0, 50), 
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'profile', child: Text('ดูหน้าโปรไฟล์')),
                  const PopupMenuItem<String>(value: 'setting', child: Text('การตั้งค่า')),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('ออกจากระบบ', style: GoogleFonts.carlito(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
                // --- child: แสดง Avatar ---
                child: CircleAvatar(
                  radius: 20, // ขนาด Avatar
                  backgroundColor: Colors.grey.shade300, // สีพื้นหลังเผื่อไม่มีรูป
                  // ใช้ Obx อีกชั้นเพื่อติดตาม userProfileImageUrl
                  child: Obx(() {
                      final imageUrl = loginController.userProfileImageUrl.value;
                      // ตรวจสอบว่าเป็น URL หรือ Asset หรือ ค่าว่าง
                      if (imageUrl.startsWith('http')) {
                          // <<<--- [TASK 12.3 - เริ่มแก้ไข] ---
                          // (ลบ Image.network)
                          // return ClipOval(
                          //     child: Image.network(
                          //         imageUrl,
                          //         ...
                          //     )
                          // );
                          
                          // (ใช้ CachedNetworkImage แทน)
                          return ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                              errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white),
                            ),
                          );
                          // <<<--- [TASK 12.3 - สิ้นสุดการแก้ไข] ---
                          
                      } else if (imageUrl.startsWith('assets/')) {
                          // ถ้าเป็น Asset ใช้ Image.asset (เหมือนเดิม)
                          return ClipOval(child: Image.asset(imageUrl, fit: BoxFit.cover, width: 40, height: 40));
                      } else {
                          // ถ้าเป็นค่าว่าง
                          return const Icon(Icons.person, color: Colors.white);
                      }
                  }),
                ),
              ),
            );
          } else {
            // --- ถ้ายังไม่ได้ Login: แสดงปุ่ม "ล็อคอิน" ---
            return TextButton(
              onPressed: () {
                filterController.clearSearchFocus(tag); // เคลียร์ Focus
                FocusScope.of(context).unfocus();
                Get.offAllNamed(AppRoutes.LOGIN); // ไปหน้า Login (ล้าง Stack)
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white), // สีตัวอักษร
              child: const Text(
                "ล็อคอิน",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // ลดขนาด Font ลงเล็กน้อย
              ),
            );
          }
        }),
        const SizedBox(width: 10), // ระยะห่างขอบขวา
      ],
      // --- Background Gradient ---
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[200]!, Colors.blue[200]!],
            begin: Alignment.centerLeft,
            transform: const GradientRotation(3.0),
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  // --- กำหนด preferredSize ให้ตรงกับ toolbarHeight ---
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}