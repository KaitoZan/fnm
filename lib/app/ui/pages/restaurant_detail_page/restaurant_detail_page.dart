// lib/app/ui/pages/restaurant_detail_page/restaurant_detail_page.dart
import 'dart:io'; // (File) - อาจจะไม่จำเป็นต้องใช้ในไฟล์นี้โดยตรง

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/bt_scrolltop.dart';
import 'restaurant_detail_controller.dart';
import 'widgets/detail_appbar.dart';
import 'widgets/detail_description.dart';
import 'widgets/detail_head_banner_text.dart';
import 'widgets/detail_head_image.dart';
import 'widgets/detail_menu_image.dart';
import 'widgets/detail_promotion.dart';
import 'widgets/review.dart';
import 'widgets/scrollctrl.dart'; // Import ScrollpageController

// --- 1. เปลี่ยนเป็น GetView<RestaurantDetailController> ---
class RestaurantDetailPage extends GetView<RestaurantDetailController> {
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  // --- 2. เพิ่ม tag getter เพื่อให้ GetView หา Controller หลักเจอ ---
  @override
  String? get tag => restaurantId;

  @override
  Widget build(BuildContext context) {
    // --- 3. สร้าง Tag แบบไดนามิกสำหรับ Scroll Controller ---
    final String scrollTag = 'detail_scroll_$restaurantId';

    // --- 4. หา Scroll Controller ด้วย Tag ที่ถูกต้อง ---
    final ScrollpageController scrollpageController =
        Get.find<ScrollpageController>(tag: scrollTag); // <<<--- แก้ไข Tag ตรงนี้

    // --- 5. Controller หลัก (controller) ได้มาจาก GetView + tag แล้ว ---
    // (ไม่ต้อง Get.find<RestaurantDetailController> เอง)
    // final RestaurantDetailController controller =
    //     Get.find<RestaurantDetailController>(tag: restaurantId); // ไม่ต้องทำ

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // ซ่อน Keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.white, // สีพื้นหลัง Scaffold
        // ส่ง restaurantId ให้ AppBar
        appBar: DetailAppbar(restaurantId: restaurantId),
        body: Container(
          // Background Gradient ของ Body
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.pink[200]!],
            ),
          ),
          child: Stack( // ใช้ Stack เพื่อวางปุ่ม Scroll-to-top
            children: [
              Column( // Column หลัก
                children: [
                  Expanded( // ส่วนเนื้อหาสีขาวขอบมน
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      // --- ใช้ SingleChildScrollView เลื่อนเนื้อหา ---
                      child: SingleChildScrollView(
                        controller: scrollpageController.scrollController, // <<<--- ใช้ ScrollController ที่ find มา
                        padding: const EdgeInsets.symmetric(horizontal: 0.0), // Padding แนวนอนเป็น 0
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() { // ใช้ Obx เพื่อรอข้อมูล restaurant จาก controller
                              // ถ้ายังไม่มีข้อมูล ให้แสดง Loading
                              if (controller.restaurant.value == null) {
                                // แสดง Loading กลางจอ (ให้มีขนาด)
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: const Center(child: CircularProgressIndicator())
                                );
                              }
                              // ถ้ามีข้อมูลแล้ว แสดง Widget ต่างๆ
                              final restaurant = controller.restaurant.value!;
                              // ดึงข้อมูลรูปเมนูและโปรโมชั่นจาก Model
                              final List<String> menuImages = restaurant.menuImages;
                              final List<String> promotion = restaurant.promotion;

                              return Column(
                                children: [
                                  DetailHeadImage(restaurantId: restaurantId),
                                  DetailHeadBannerText(restaurantId: restaurantId),
                                  Padding( // Padding รอบเนื้อหาหลัก
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DetailDescription(restaurantId: restaurantId),
                                        const SizedBox(height: 20),
                                        DetailMenuImage(menuImages: menuImages), // ส่ง List รูปเมนู
                                        const SizedBox(height: 20),
                                        Promotion(promotion: promotion), // ส่ง List โปรโมชั่น
                                        const SizedBox(height: 30.0),
                                        Review(restaurantId: restaurantId), // Widget รีวิว
                                        const SizedBox(height: 30.0), // ระยะห่างล่างสุด
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // --- 6. ปุ่ม Scroll To Top (ใช้ tag ที่ถูกต้อง) ---
              BtScrollTop(tag: scrollTag), // <<<--- แก้ไข Tag ตรงนี้
            ],
          ),
        ),
      ),
    );
  }
}