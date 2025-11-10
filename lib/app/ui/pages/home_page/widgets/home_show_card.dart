// lib/app/ui/pages/home_page/widgets/home_show_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../global_widgets/filter_ctrl.dart';
// import '../../restaurant_detail_page/restaurant_detail_controller.dart'; // ไม่จำเป็น
// import '../../restaurant_detail_page/restaurant_detail_page.dart'; // ไม่จำเป็น

import 'home_restaurant_card.dart';

class ShowCardHome extends StatelessWidget {
  const ShowCardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find<FilterController>();
    return Obx(() { // ใช้ Obx เพื่อติดตาม filteredRestaurantList
      if (filterController.filteredRestaurantList.isEmpty) {
        return const Center(
          child: Padding( // เพิ่ม Padding
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              'ไม่พบร้านอาหารที่ตรงกับการค้นหา',
              style: TextStyle(fontSize: 16, color: Colors.grey), // ลดขนาด Font เล็กน้อย
            ),
          ),
        );
      }
      // แสดง List ร้านอาหาร
      return Column(
        children: filterController.filteredRestaurantList.map((restaurant) {
          return HomeRestaurantCard(
            imageUrl: restaurant.imageUrl,
            restaurantName: restaurant.restaurantName,
            description: restaurant.description,
            rating: restaurant.rating,
            isOpen: restaurant.isOpen, // ส่ง RxBool ไปตรงๆ
            showMotorcycleIcon: restaurant.showMotorcycleIcon,
            distanceInMeters: restaurant.distanceInMeters, // <<<--- [เพิ่ม] ส่งระยะทาง
            onTap: () {
                // --- แก้ไข: ใช้ restaurant.id ตรงๆ (ไม่ต้อง .toString()) ---
                final String restaurantIdString = restaurant.id; // <<<--- แก้ไข
                Get.toNamed(
                  AppRoutes.RESTAURANTDETAIL + '/$restaurantIdString', // ใช้ String ID ใน Route Name
                  parameters: {'restaurantId': restaurantIdString}, // ส่ง parameters เป็น String ID
                );
            },
          );
        }).toList(),
      );
    });
  }
}