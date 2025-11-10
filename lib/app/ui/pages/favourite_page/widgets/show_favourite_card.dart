// lib/app/ui/pages/favourite_page/widgets/show_favourite_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../global_widgets/filter_ctrl.dart';
import '../../home_page/widgets/home_restaurant_card.dart'; // <<<--- ใช้ HomeRestaurantCard
import '../../login_page/login_controller.dart';
// import '../../restaurant_detail_page/restaurant_detail_controller.dart'; // ไม่จำเป็น
// import '../../restaurant_detail_page/restaurant_detail_page.dart'; // ไม่จำเป็น

class ShowFavouriteCard extends StatelessWidget {
  // <<<--- เพิ่ม const constructor
  const ShowFavouriteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final FilterController filterController = Get.find<FilterController>();

    return Column(
      children: [
        Obx(() {
          // --- เช็ค Login ---
          if (!loginController.isLoggedIn.value) {
            return const Center(
              child: Padding( // <<<--- เพิ่ม Padding
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'กรุณาเข้าสู่ระบบเพื่อดูรายการโปรด',
                  style: TextStyle(fontSize: 16, color: Colors.grey), // <<<--- ลดขนาด Font
                ),
              ),
            );
          }

          // --- ใช้ filterController.filteredFavoriteList ---
          if (filterController.filteredFavoriteList.isEmpty) {
            return const Center(
              child: Padding( // <<<--- เพิ่ม Padding
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'ไม่พบร้านอาหารที่ตรงกับการค้นหา\nหรือคุณยังไม่มีร้านอาหารในรายการโปรด', // <<<--- ขึ้นบรรทัดใหม่
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey), // <<<--- ลดขนาด Font
                ),
              ),
            );
          }
          // --- แสดง List โดยใช้ map ---
          return Column(
            children: filterController.filteredFavoriteList.map((restaurant) {
              // ใช้ HomeRestaurantCard แสดงผล
              return HomeRestaurantCard(
                imageUrl: restaurant.imageUrl,
                restaurantName: restaurant.restaurantName,
                description: restaurant.description,
                rating: restaurant.rating,
                isOpen: restaurant.isOpen, // ส่ง RxBool
                showMotorcycleIcon: restaurant.showMotorcycleIcon,
                distanceInMeters: restaurant.distanceInMeters, // <<<--- [เพิ่ม] ส่งระยะทาง
                onTap: () {
                  // --- แก้ไข: ใช้ restaurant.id ตรงๆ (ไม่ต้อง .toString()) ---
                  final String restaurantIdString = restaurant.id; // <<<--- แก้ไข
                  Get.toNamed(
                    AppRoutes.RESTAURANTDETAIL + '/$restaurantIdString', // <<<--- ใช้ String ID
                    parameters: {'restaurantId': restaurantIdString}, // <<<--- ส่ง String ID
                  );
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}