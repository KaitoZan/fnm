// lib/app/ui/pages/my_shop_page/widgets/my_shop_show_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
// import '../../restaurant_detail_page/restaurant_detail_controller.dart'; // ไม่จำเป็น
// import '../../restaurant_detail_page/restaurant_detail_page.dart'; // ไม่จำเป็น

import '../my_shop_controller.dart';
import 'my_shop_card.dart';

class Showshopcard extends StatelessWidget {
  // <<<--- เพิ่ม const constructor
  const Showshopcard({super.key});

  @override
  Widget build(BuildContext context) {
    final MyShopController controller = Get.find<MyShopController>();
    return Obx(
      () {
          // --- เพิ่ม: เช็คว่ามีร้านค้าหรือไม่ ---
          if (controller.myOwnerShopList.isEmpty) {
             return const Center(
                child: Padding( // <<<--- เพิ่ม Padding
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text(
                    'คุณยังไม่มีร้านค้า\nเพิ่มร้านค้าของคุณได้เลย!', // <<<--- ข้อความแนะนำ
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
          }
          // --- แสดง List ร้านค้า ---
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: controller.myOwnerShopList.asMap().entries.map((entry) {
              final index = entry.key;
              final restaurant = entry.value;
              return Column(
                children: [
                  // ใช้ MyShopCard แสดงผล
                  MyShopCard(
                    imageUrl: restaurant.imageUrl,
                    restaurantName: restaurant.restaurantName,
                    description: restaurant.description,
                    rating: restaurant.rating,
                    isOpen: restaurant.isOpen, // ส่ง RxBool
                    showMotorcycleIcon: restaurant.showMotorcycleIcon,
                    shopId: restaurant.id, // ส่ง String ID
                    onTap: () {
                      // --- แก้ไข: ใช้ restaurant.id ตรงๆ (ไม่ต้อง .toString()) ---
                      final String restaurantIdString = restaurant.id; // <<<--- แก้ไข
                      Get.toNamed(
                        AppRoutes.RESTAURANTDETAIL + '/$restaurantIdString', // <<<--- ใช้ String ID
                        parameters: {'restaurantId': restaurantIdString}, // <<<--- ส่ง String ID
                      );
                    },
                  ),
                  // เพิ่ม SizedBox ด้านล่างสุด
                  if (index == controller.myOwnerShopList.length - 1)
                    const SizedBox(height: 80), // <<<--- เพิ่ม const
                ],
              );
            }).toList(),
          );
      }
    );
  }
}