// lib/app/ui/pages/restaurant_detail_page/widgets/detail_head_banner_text.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_widgets/dotline.dart';
import '../../../global_widgets/filter_ctrl.dart';
import '../../login_page/login_controller.dart';
import '../restaurant_detail_controller.dart';

class DetailHeadBannerText extends StatelessWidget {
  final String restaurantId;
  // <<<--- เพิ่ม const constructor
  const DetailHeadBannerText({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    // --- หา Controllers ---
    final RestaurantDetailController controller = Get.find<RestaurantDetailController>(tag: restaurantId);
    final LoginController loginController = Get.find<LoginController>();
    final FilterController filterController = Get.find<FilterController>();

    return Column(
      children: [
        // --- เส้นประ ---
        Dotline(
          gradientColors: LinearGradient(
            colors: [Colors.blue.shade50, Colors.pink.shade200], // สี Gradient
          ),
          height: 4,
          dashWidth: 6,
        ),
        // --- แถบชื่อร้านและปุ่ม Favorite ---
        Container(
          height: 56, // ความสูงแถบ (ปรับได้)
          color: Colors.pink.shade50, // สีพื้นหลังแถบ
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- ชื่อร้าน ---
              Align(
                alignment: Alignment.center,
                // ใช้ Obx เพื่อรอข้อมูล restaurant
                child: Obx(() => Text(
                  // ใช้ ?. และ ?? เพื่อจัดการ null
                  controller.restaurant.value?.restaurantName ?? 'กำลังโหลด...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87, // <<<--- ปรับสีให้เข้มขึ้นเล็กน้อย
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // <<<--- จัดกลางเผื่อชื่อยาว
                  overflow: TextOverflow.ellipsis, // <<<--- ตัดข้อความถ้าชื่อยาวมาก
                  maxLines: 1,
                )),
              ),
              // --- ปุ่ม Favorite ---
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // <<<--- ปรับ Padding
                  child: Obx(() {
                    // Check null ก่อน
                    if (controller.restaurant.value == null) {
                      return const SizedBox(width: 48); // Widget ว่างขนาดเท่า IconButton
                    }
                    final restaurant = controller.restaurant.value!;

                    // --- [เพิ่ม] ตรวจสอบว่าเป็นเจ้าของร้านหรือไม่ ---
                    final bool isOwner = loginController.isLoggedIn.value &&
                                      restaurant.ownerId == loginController.userId.value;

                    return Row( // <<<--- [แก้ไข] ใช้ Row
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        // --- [เพิ่ม] ปุ่มรายงานร้าน (แสดงเมื่อ *ไม่ใช่* เจ้าของ และ Login) ---
                        if (!isOwner && loginController.isLoggedIn.value)
                          IconButton(
                            icon: Icon(
                              Icons.flag_outlined,
                              color: Colors.red.shade600,
                              size: 28,
                            ),
                            tooltip: 'รายงานร้านค้านี้',
                            onPressed: () {
                              // เรียกฟังก์ชันรายงานร้านใน Controller
                              controller.showReportRestaurantDialog();
                            },
                          ),

                        // --- ปุ่ม Favorite (Bookmark) (เหมือนเดิม) ---
                        IconButton(
                          icon: Icon(
                            // ไอคอน Bookmark (หัวใจ)
                            restaurant.isFavorite.value
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            // สีไอคอน
                            color: restaurant.isFavorite.value
                                ? Colors.amber.shade700 // <<<--- ปรับสีให้เข้มขึ้น
                                : Colors.grey.shade600, // <<<--- ปรับสี
                            size: 28, // <<<--- ปรับขนาดไอคอน
                          ),
                          tooltip: restaurant.isFavorite.value ? 'ลบออกจากโปรด' : 'เพิ่มในรายการโปรด', // <<<--- เพิ่ม Tooltip
                          onPressed: loginController.isLoggedIn.value
                              ? () {
                                  // --- แก้ไข: แปลง restaurant.id (int) เป็น String ---
                                  filterController.toggleFavorite(restaurant.id.toString());
                                }
                              : () { // กรณีไม่ได้ Login
                                  Get.snackbar(
                                    'System',
                                    'กรุณาเข้าสู่ระบบเพื่อเพิ่มร้านค้าในรายการโปรด',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.black.withOpacity(0.1),
                                    colorText: Colors.black,
                                    duration: const Duration(milliseconds: 1200), // <<<--- นานขึ้นเล็กน้อย
                                  );
                                },
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        // --- เส้นประ ---
        Dotline(
          gradientColors: LinearGradient(
            colors: [Colors.blue.shade50, Colors.pink.shade200], // สี Gradient
          ),
          height: 4,
          dashWidth: 6,
        ),
      ],
    );
  }
}