// lib/app/ui/pages/setting_page/setting_page.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart';
// import 'package:food_near_me_app/app/ui/pages/aboutapp_page/aboutapp_page.dart'; // ใช้ Get.toNamed
// import 'package:food_near_me_app/app/ui/pages/contact_us_page/contact_us_page.dart'; // ใช้ Get.toNamed
import 'package:food_near_me_app/app/ui/pages/setting_page/setting_controller.dart';
// import 'package:food_near_me_app/app/ui/pages/terms_conditions_page/terms_conditions_page.dart'; // ใช้ Get.toNamed
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/logo.dart';
// import '../login_page/login_controller.dart'; // ไม่จำเป็นต้อง import LoginController ที่นี่
// import '../privacypolicy_page/privacypolicy_page.dart'; // ใช้ Get.toNamed

class SettingPage extends GetView<SettingController> {
  SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final LoginController loginController = Get.find<LoginController>(); // ไม่ต้องใช้แล้ว

    return Scaffold(
      appBar: AppBar(
        leading: const Back3Bt(), // ใช้ const ได้
        title: const Text('ตั้งค่า'),
        backgroundColor: Colors.blue[200],
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        toolbarHeight: 8 * 9, // ใช้ค่าคงที่ kToolbarHeight * 1.5 หรือค่าที่เหมาะสม
      ),

      body: Container(
        // ใช้ const ได้
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[300]!, Colors.purple[100]!, Colors.blue[200]!],
            begin: Alignment.topCenter,
            transform: const GradientRotation(3.0),
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // <<<--- เพิ่ม const
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- ปุ่ม นโยบายความเป็นส่วนตัว ---
                OutlinedButton(
                  onPressed: () {
                     Get.toNamed(AppRoutes.PRIVACYPOLICY); // ใช้ Get.toNamed
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(8 * 7), // <<<--- เพิ่ม const
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Align( // <<<--- เพิ่ม const
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [ // <<<--- เพิ่ม const
                        Text('นโยบายความเป็นส่วนตัว', style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // <<<--- เพิ่ม const
                // --- ปุ่ม เงื่อนไขและข้อตกลง ---
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.TERMSCONDITIONS); // ใช้ Get.toNamed
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(8 * 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('เงื่อนไขและข้อตกลง', style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // <<<--- เพิ่ม const
                // --- ปุ่ม เกี่ยวกับแอป ---
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.ABOUTAPP); // ใช้ Get.toNamed
                  },
                   style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(8 * 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                   child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('เกี่ยวกับแอป', style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // <<<--- เพิ่ม const
                // --- ปุ่ม ติดต่อเรา ---
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.CONTACTUS); // ใช้ Get.toNamed
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(8 * 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('ติดต่อเรา', style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8), // <<<--- เพิ่ม const
                // --- แสดงเวอร์ชัน ---
                Container(
                  width: double.infinity,
                  height: 8 * 7, // <<<--- เพิ่ม const
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // <<<--- แก้ไข Padding เป็น 16.0
                    child: Row(
                      children: [ // <<<--- เพิ่ม const
                        const Text('เวอร์ชั่น', style: TextStyle(color: Colors.black87)),
                        const Spacer(),
                        Text(' 0.0.11', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8), // <<<--- เพิ่ม const

                const Expanded(child: SizedBox()), // <<<--- เพิ่ม const
                const Logo(width: 250), // <<<--- เพิ่ม const
              ],
            ),
          ),
        ),
      ),
    );
  }
}