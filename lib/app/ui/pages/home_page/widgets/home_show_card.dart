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
      
      // <<<--- [TASK 16.6 - เริ่มแก้ไข] ---
      return ListView.builder(
        itemCount: filterController.filteredRestaurantList.length,
        physics: const NeverScrollableScrollPhysics(), 
        shrinkWrap: true, 
        itemBuilder: (context, index) {
          final restaurant = filterController.filteredRestaurantList[index];
          return HomeRestaurantCard(
            imageUrl: restaurant.imageUrl,
            restaurantName: restaurant.restaurantName,
            description: restaurant.description,
            rating: restaurant.rating,
            isOpen: restaurant.isOpen, 
            
            // <<< [แก้ไข]
            // showMotorcycleIcon: restaurant.showMotorcycleIcon,
            hasDelivery: restaurant.hasDelivery,
            hasDineIn: restaurant.hasDineIn, // <<< [เพิ่ม]

            distanceInMeters: restaurant.distanceInMeters, 
            onTap: () {
                final String restaurantIdString = restaurant.id; 
                Get.toNamed(
                  AppRoutes.RESTAURANTDETAIL + '/$restaurantIdString', 
                  parameters: {'restaurantId': restaurantIdString}, 
                );
            },
          );
        },
      );
      // <<<--- [TASK 16.6 - สิ้นสุดการแก้ไข] ---
    });
  }
}