// lib/app/ui/pages/restaurant_detail_page/restaurant_detail_page.dart
import 'dart:io'; 

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// <<<--- 1. Import MenuItem
import '../../../model/menu_item.dart';
import '../../global_widgets/bt_scrolltop.dart';
import 'restaurant_detail_controller.dart';
// ... (imports อื่นๆ)
import 'widgets/detail_appbar.dart';
import 'widgets/detail_description.dart';
import 'widgets/detail_head_banner_text.dart';
import 'widgets/detail_head_image.dart';
import 'widgets/detail_menu_image.dart';
import 'widgets/detail_promotion.dart';
import 'widgets/review.dart';
import 'widgets/scrollctrl.dart';
// ...

class RestaurantDetailPage extends GetView<RestaurantDetailController> {
  // ... (constructor และ tag getter เหมือนเดิม) ...
  final String restaurantId;
  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  String? get tag => restaurantId;

  @override
  Widget build(BuildContext context) {
    // ... (Scroll controller logic เหมือนเดิม) ...
    final String scrollTag = 'detail_scroll_$restaurantId';
    final ScrollpageController scrollpageController =
        Get.find<ScrollpageController>(tag: scrollTag); 

    return GestureDetector(
      // ... (Scaffold, AppBar, Background Gradient เหมือนเดิม) ...
      child: Scaffold(
        backgroundColor: Colors.white, 
        appBar: DetailAppbar(restaurantId: restaurantId),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.pink[200]!],
            ),
          ),
          child: Stack( 
            children: [
              Column( 
                children: [
                  Expanded( 
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollpageController.scrollController, 
                        padding: const EdgeInsets.symmetric(horizontal: 0.0), 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() { 
                              if (controller.restaurant.value == null) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: const Center(child: CircularProgressIndicator())
                                );
                              }
                              
                              final restaurant = controller.restaurant.value!;
                              
                              final List<MenuItem> menuItems = restaurant.menuItems;
                              final List<String> promotion = restaurant.promotion;
                              
                              // (ลบ: final List<String> galleryImages = promotion.where(...))
                              
                              // <<< ใช้ Field ใหม่
                              final List<String> galleryImages = restaurant.galleryImages; 
                              // <<<--- สิ้นสุดการแก้ไข ---


                              return Column(
                                children: [
                                  DetailHeadImage(restaurantId: restaurantId),
                                  DetailHeadBannerText(restaurantId: restaurantId),
                                  Padding( 
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DetailDescription(restaurantId: restaurantId),
                                        const SizedBox(height: 20),
                                        
                                        // <<<--- [แก้ไข] ส่งข้อมูลที่ถูกต้อง
                                        DetailMenuImage(
                                          galleryImages: galleryImages, // <<< (ข้อมูล Gallery จริง)
                                          menuItems: menuItems,
                                        ),
                                        // <<<--- สิ้นสุดการแก้ไข ---

                                        const SizedBox(height: 20),
                                        Promotion(promotion: promotion), // (Promotion Widget ใช้ข้อมูล Promotion)
                                        const SizedBox(height: 30.0),
                                        Review(restaurantId: restaurantId), 
                                        const SizedBox(height: 30.0), 
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
              BtScrollTop(tag: scrollTag), 
            ],
          ),
        ),
      ),
    );
  }
}