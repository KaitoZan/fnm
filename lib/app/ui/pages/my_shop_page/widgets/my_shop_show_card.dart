// lib/app/ui/pages/my_shop_page/widgets/my_shop_show_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

import '../my_shop_controller.dart';
import 'my_shop_card.dart';

class Showshopcard extends StatelessWidget {
  const Showshopcard({super.key});

  @override
  Widget build(BuildContext context) {
    final MyShopController controller = Get.find<MyShopController>();
    return Obx(
      () {
          if (controller.myOwnerShopList.isEmpty) {
             return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text(
                    'คุณยังไม่มีร้านค้า\nเพิ่มร้านค้าของคุณได้เลย!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
          }
          
          return ListView.builder(
            itemCount: controller.myOwnerShopList.length,
            physics: const NeverScrollableScrollPhysics(), 
            shrinkWrap: true, 
            itemBuilder: (context, index) {
              final restaurant = controller.myOwnerShopList[index];
              return Column(
                children: [
                  // ใช้ MyShopCard แสดงผล
                  MyShopCard(
                    imageUrl: restaurant.imageUrl,
                    restaurantName: restaurant.restaurantName,
                    description: restaurant.description,
                    rating: restaurant.rating,
                    isOpen: restaurant.isOpen, 
                    
                    status: restaurant.status, // <<< 1. [เพิ่ม] ส่ง status string

                    hasDelivery: restaurant.hasDelivery, 
                    hasDineIn: restaurant.hasDineIn, 
                    
                    shopId: restaurant.id, 
                    onTap: () {
                      final String restaurantIdString = restaurant.id;
                      Get.toNamed(
                        AppRoutes.RESTAURANTDETAIL + '/$restaurantIdString', 
                        parameters: {'restaurantId': restaurantIdString}, 
                      );
                    },
                  ),
                  if (index == controller.myOwnerShopList.length - 1)
                    const SizedBox(height: 80),
                ],
              );
            },
          );
      }
    );
  }
}