// lib/app/ui/pages/home_page/widgets/home_slide_image.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/model/bannerslide.dart';
import 'package:get/get.dart';
// <<<--- [TASK 12.3 - เพิ่ม] Import
import 'package:cached_network_image/cached_network_image.dart';

import '../../../global_widgets/slide_ctrl.dart'; // <<<--- Import SlideController
import '../../../../routes/app_routes.dart'; // <<<--- Import AppRoutes

class HomeSlideImage extends StatelessWidget {
  // <<<--- เพิ่ม const constructor
  HomeSlideImage({super.key});

  @override
  Widget build(BuildContext context) {
    // <<<--- หา Controller ใน build
    final SlideController controller = Get.find<SlideController>();

    return Column(
      children: [
        SizedBox(
          height: 120, // ความสูงของ Slide
          child: Obx( // ใช้ Obx เพื่อ re-render เมื่อ displayBannerItems เปลี่ยน
            () {
              if (controller.displayBannerItems.isEmpty) {
                 return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Center(child: Text("ไม่พบร้านค้าแนะนำ")),
                 );
              }

              return PageView.builder(
                controller: controller.pageController, // Controller สำหรับ PageView
                itemCount: controller.displayBannerItems.length, // จำนวน Item ที่จะแสดง (รวมตัวซ้ำหัวท้าย)
                onPageChanged: controller.onPageChanged, // Callback เมื่อเปลี่ยนหน้า
                itemBuilder: (BuildContext context, int index) {
                  // ดึงข้อมูล BannerItem สำหรับ index ปัจจุบัน
                  final BannerItem bannerItem = controller.displayBannerItems[index];

                  // แสดงรูปภาพ
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // <<<--- เพิ่ม const
                    child: ClipRRect( // ตัดขอบมน
                      borderRadius: BorderRadius.circular(15.0),
                      child: GestureDetector( // ทำให้กดได้
                        onTap: () {
                          // --- แก้ไข Navigation ---
                          controller.navigateToRestaurantDetail(bannerItem.restaurantId);
                        },
                        
                        // <<<--- [TASK 12.3 - เริ่มแก้ไข] ---
                        // (ลบ Image.network)
                        // child: Image.network( 
                        //   bannerItem.imagePath,
                        //   fit: BoxFit.cover, 
                        //   loadingBuilder: (context, child, loadingProgress) {
                        //     ...
                        //   },
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                        // ),

                        // (ใช้ CachedNetworkImage แทน)
                        child: CachedNetworkImage(
                          imageUrl: bannerItem.imagePath,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.pink.shade300)),
                          errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                        ),
                        // <<<--- [TASK 12.3 - สิ้นสุดการแก้ไข] ---
                      ),
                    ),
                  );
                },
              );
            }
          ),
        ),

        // --- ส่วน Indicator (จุดๆ แสดงหน้าปัจจุบัน) ---
        Obx(() {
          // (Logic การแสดง Indicator ... เหมือนเดิม)
          if (controller.originalBannerItems.length < 2) {
            return const SizedBox.shrink(); 
          }
          int actualIndex = controller.currentPage.value;
          if (controller.originalBannerItems.length > 0) {
            if (actualIndex == 0) {
              actualIndex = controller.originalBannerItems.length;
            } else if (actualIndex == controller.displayBannerItems.length - 1) {
              actualIndex = 1;
            }
            actualIndex -= 1; 
          } else {
             return const SizedBox.shrink(); 
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: List.generate(controller.originalBannerItems.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0), 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: actualIndex == index
                        ? Colors.pink.shade300 
                        : Colors.grey.shade400, 
                  ),
                );
            }),
          );
        }),
      ],
    );
  }
}