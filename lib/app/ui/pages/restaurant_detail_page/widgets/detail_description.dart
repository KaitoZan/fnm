// lib/app/ui/pages/restaurant_detail_page/widgets/detail_description.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/star_rating.dart';
import '../../../global_widgets/status_tag.dart';
import '../restaurant_detail_controller.dart';

class DetailDescription extends StatelessWidget {
  final String restaurantId;
  const DetailDescription({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final RestaurantDetailController controller =
        Get.find<RestaurantDetailController>(tag: restaurantId);

    return Obx(() {
      final restaurant = controller.restaurant.value;
      if (restaurant == null) {
        return const SizedBox.shrink(); // หรือ Loading
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.description ?? 'ไม่มีรายละเอียดเพิ่มเติม',
            style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10.0),
          Text(
            "เวลาเปิดร้าน: ${restaurant.openingHours ?? 'ไม่มีข้อมูล'}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          const SizedBox(height: 5.0),
          Text(
            "เบอร์โทร: ${restaurant.phoneNumber ?? 'ไม่มีข้อมูล'}", // phone_no
            style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "พิกัดที่ตั้ง: ${restaurant.location ?? 'ไม่มีข้อมูล'}",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(width: 8),
              if (restaurant.latitude != null && restaurant.longitude != null)
                 GestureDetector(
                    onTap: () {
                      controller.launchMap(
                        restaurant.latitude,
                        restaurant.longitude,
                        restaurant.restaurantName,
                      );
                    },
                    child: Icon(
                      Icons.gps_fixed,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                 ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8.0),
          Obx(
            () => StatusTag(
              isOpen: restaurant.isOpen.value,
              showMotorcycleIcon: restaurant.showMotorcycleIcon,
              fontSize: 14,
              iconSize: 20,
              showOpenStatus: true,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              StarRating(
                rating: restaurant.rating,
                size: 20,
              ),
              const SizedBox(width: 10),
              // --- 1. แก้ไข: แสดงผล 'type' (String?) ---
              if (restaurant.type != null && restaurant.type!.isNotEmpty) // เช็ค null และ empty
                 Expanded(
                   child: Text(
                     "ประเภท: ${restaurant.type}", // <<<--- แสดง String? type
                     style: TextStyle(
                       fontSize: 14.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.pink[700],
                     ),
                     overflow: TextOverflow.ellipsis,
                   ),
                 ),
            ],
          ),
        ],
      );
    });
  }
}