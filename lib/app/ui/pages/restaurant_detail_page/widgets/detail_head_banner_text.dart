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
          // <<<--- [TASK 8 - เริ่มแก้ไข] ---
          // เปลี่ยนจาก Stack เป็น Row
          child: Row(
            children: [
              
              // --- 1. ส่วนด้านซ้าย: ปุ่ม Favorite (Bookmark) ---
              SizedBox(
                width: 56, // กว้างเท่าๆ IconButton (เผื่อ padding 12 + icon 28 + padding 12)
                child: Obx(() {
                  if (controller.restaurant.value == null) {
                    return const SizedBox.shrink(); // ว่าง
                  }
                  final restaurant = controller.restaurant.value!;
                  
                  return Align(
                    alignment: Alignment.center, // จัดกลางใน SizedBox
                    child: IconButton(
                      icon: Icon(
                        restaurant.isFavorite.value
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: restaurant.isFavorite.value
                            ? Colors.amber.shade700
                            : Colors.grey.shade600,
                        size: 28, 
                      ),
                      tooltip: restaurant.isFavorite.value ? 'ลบออกจากโปรด' : 'เพิ่มในรายการโปรด',
                      onPressed: loginController.isLoggedIn.value
                          ? () {
                              filterController.toggleFavorite(restaurant.id.toString());
                            }
                          : () { 
                              Get.snackbar(
                                'System',
                                'กรุณาเข้าสู่ระบบเพื่อเพิ่มร้านค้าในรายการโปรด',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.black.withOpacity(0.1),
                                colorText: Colors.black,
                                duration: const Duration(milliseconds: 1200),
                              );
                            },
                    ),
                  );
                }),
              ),

              // --- 2. ส่วนกลาง: ชื่อร้าน (ขยายเต็ม) ---
              Expanded(
                child: Obx(() => Text(
                  controller.restaurant.value?.restaurantName ?? 'กำลังโหลด...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // <<<--- จัดกลาง
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 1,
                )),
              ),

              // --- 3. ส่วนด้านขวา: ปุ่ม Report ---
              SizedBox(
                width: 56, // กว้างเท่าๆ IconButton (เผื่อ padding 12 + icon 28 + padding 12)
                child: Obx(() {
                  if (controller.restaurant.value == null) {
                    return const SizedBox.shrink(); // ว่าง
                  }
                  final restaurant = controller.restaurant.value!;
                  final bool isOwner = loginController.isLoggedIn.value &&
                                      restaurant.ownerId == loginController.userId.value;

                  // แสดงปุ่ม Report (ถ้าไม่ใช่เจ้าของ และ Login)
                  if (!isOwner && loginController.isLoggedIn.value) {
                    return Align(
                      alignment: Alignment.center, // จัดกลางใน SizedBox
                      child: IconButton(
                        icon: Icon(
                          Icons.flag_outlined,
                          color: Colors.red.shade600,
                          size: 28,
                        ),
                        tooltip: 'รายงานร้านค้านี้',
                        onPressed: () {
                          controller.showReportRestaurantDialog();
                        },
                      ),
                    );
                  }
                  
                  // ถ้าเป็นเจ้าของ หรือ ไม่ได้ Login
                  return const SizedBox.shrink(); // ว่าง (เพื่อให้ชื่อร้านอยู่ตรงกลาง)
                }),
              ),
              
            ],
          ),
          // <<<--- [TASK 8 - สิ้นสุดการแก้ไข] ---
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