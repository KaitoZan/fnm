// lib/app/ui/pages/restaurant_detail_page/widgets/detail_head_image.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ใช้ DetailMenuCtrl ที่เรามีอยู่แล้ว ซึ่งจัดการ Network Image ได้
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart';

import '../restaurant_detail_controller.dart';

class DetailHeadImage extends StatelessWidget {
  final String restaurantId;
  const DetailHeadImage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    // ใช้ Get.find เพราะ Controller ถูกสร้างโดย Binding แล้ว
    final RestaurantDetailController controller =
        Get.find<RestaurantDetailController>(tag: restaurantId);

    // ใช้ Obx เพื่อ re-render เมื่อ restaurant.value เปลี่ยน
    return Obx(() {
        // ดึงข้อมูล restaurant จาก controller
        final restaurant = controller.restaurant.value;

        // ตรวจสอบว่ามีข้อมูลร้านและ URL รูปภาพหรือไม่
        // ใช้ restaurant.imageUrl ที่เป็น nullable String
        if (restaurant == null || restaurant.imageUrl == null || restaurant.imageUrl!.isEmpty) {
            // แสดง Placeholder ถ้าไม่มีรูป
            return Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.grey, // สีพื้นหลัง Placeholder
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                 child: const Center(child: Icon(Icons.storefront, color: Colors.white, size: 50)), // ไอคอนร้านค้า
            );
        }

        // แสดงรูปภาพจาก URL โดยใช้ DetailMenuCtrl
        return Container(
            height: 250,
            width: double.infinity,
            // ใช้ ClipRRect เพื่อตัดขอบมน
            child: ClipRRect(
                 borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                 // ส่ง URL รูปภาพให้ DetailMenuCtrl
                 // ใส่ ! หลัง imageUrl เพราะเราเช็ค null ไปแล้ว
                 child: DetailMenuCtrl(imageUrl: restaurant.imageUrl!, fit: BoxFit.cover),
            ),
        );
    });
  }
}