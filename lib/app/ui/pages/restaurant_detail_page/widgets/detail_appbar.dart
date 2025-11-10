// lib/app/ui/pages/restaurant_detail_page/widgets/detail_appbar.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_widgets/back3_bt.dart';
import '../../login_page/login_controller.dart';
import '../restaurant_detail_controller.dart';

class DetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String restaurantId; // รับ restaurantId (String)
  const DetailAppbar({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    // หา Controllers โดยใช้ tag
    final RestaurantDetailController controller =
        Get.find<RestaurantDetailController>(tag: restaurantId);
    final LoginController loginController = Get.find<LoginController>();

    return AppBar(
      leading: const Back3Bt(), // ปุ่ม Back
      backgroundColor: Colors.pink[200], // สีพื้นหลัง AppBar
      toolbarHeight: kToolbarHeight + 24, // ความสูง AppBar (ปรับตามต้องการ)
      automaticallyImplyLeading: false, // ไม่แสดงปุ่ม Back อัตโนมัติ
      actions: [
        Obx(() { // ใช้ Obx เพื่อรอข้อมูล restaurant และ login status
          // Check null ก่อนใช้งาน restaurant object
          if (controller.restaurant.value == null) {
            return const SizedBox.shrink(); // แสดง Widget ว่างเปล่าถ้ายังไม่มีข้อมูล
          }
          // ดึง restaurant object มาใช้หลัง check null แล้ว
          final restaurant = controller.restaurant.value!;
          final appBarActions = <Widget>[]; // List เก็บ Actions

          // ตรวจสอบว่าเป็นเจ้าของร้านหรือไม่
          if (loginController.isLoggedIn.value &&
              restaurant.ownerId == loginController.userId.value) {
            // --- ถ้าเป็นเจ้าของร้าน: แสดงปุ่ม แก้ไข และ ลบ ---
            appBarActions.add(
              Row(
                mainAxisSize: MainAxisSize.min, // ให้ Row มีขนาดพอดีกับเนื้อหา
                children: [
                  // --- ปุ่มแก้ไขร้าน ---
                  TextButton(
                    onPressed: () {
                      // --- แก้ไข: ใช้ restaurant.id ตรงๆ (ไม่ต้อง .toString()) ---
                      Get.toNamed(
                        AppRoutes.EDITRESTAURANTDETAIL + '/${restaurant.id}', // <<<--- แก้ไข
                        parameters: {'restaurantId': restaurant.id}, // <<<--- แก้ไข
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.white), // สีตัวอักษร
                    child: Text(
                      "แก้ไขร้าน",
                      style: GoogleFonts.kanit(fontSize: 16), // ลดขนาด Font ลงเล็กน้อย
                    ),
                  ),
                  // --- ปุ่มลบร้าน ---
                  TextButton(
                    onPressed: () {
                      // เรียกฟังก์ชัน deleteRestaurant ใน Controller
                      controller.deleteRestaurant();
                    },
                     style: TextButton.styleFrom(foregroundColor: Colors.red.shade700), // สีตัวอักษร
                    child: Text(
                      "ลบร้าน",
                      style: GoogleFonts.kanit(fontSize: 16), // ลดขนาด Font ลงเล็กน้อย
                    ),
                  ),
                ],
              ),
            );
          } else {
            // --- ถ้าไม่ใช่เจ้าของร้าน: แสดง Logo ---
            appBarActions.add(
              Padding( // เพิ่ม Padding ให้ Logo
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  "assets/imgs/logoHome.png", // Path Logo
                  // height: kToolbarHeight - 16, // ปรับความสูงตามต้องการ
                  fit: BoxFit.contain,
                ),
              ),
            );
          }
          // แสดง Actions ที่สร้างไว้
          return Row(children: appBarActions);
        }),
        const SizedBox(width: 16), // ระยะห่างขอบขวา
      ],
      // --- Background Gradient ---
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[200]!, Colors.blue[200]!], // สี Gradient
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