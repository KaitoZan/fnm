// lib/app/ui/pages/my_shop_page/widgets/my_shop_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ใช้ DetailMenuCtrl
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart';

import '../../../global_widgets/star_rating.dart';
import '../../../global_widgets/status_tag.dart';
import '../my_shop_controller.dart';

class MyShopCard extends StatelessWidget {
  final String? imageUrl; // อาจเป็น null (res_img)
  final String restaurantName; // res_name
  final String description;
  final double rating;
  final RxBool isOpen; // รับ RxBool จาก Model
  
  final String status; // <<< 1. [เพิ่ม] รับ status string

  final bool hasDelivery; // (เพิ่ม)
  final bool hasDineIn; // (เพิ่ม)
  
  final VoidCallback? onTap;
  final String shopId; // <<< รับ String

  const MyShopCard({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.description,
    this.rating = 0.0,
    required this.isOpen,
    required this.status, // <<< 2. [เพิ่ม] status string
    required this.hasDelivery,
    required this.hasDineIn,
    this.onTap,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final MyShopController myShopController = Get.find<MyShopController>();
    
    // 3. ตรวจสอบสถานะ
    final bool isSuspended = status == 'suspended';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
          onTap: onTap, 
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                   borderRadius: BorderRadius.circular(10.0),
                   child: Container(
                      width: 50, height: 50, color: Colors.grey[200],
                      child: (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DetailMenuCtrl(imageUrl: imageUrl!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.storefront, color: Colors.grey)),
                   ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( restaurantName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4.0),
                      Text( description, style: TextStyle(fontSize: 10, color: Colors.grey[700]), maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. Star Rating
                          StarRating( rating: rating, size: 10, onRatingChanged: (newRating) {} ),
                          
                          // 2. Status Icons + Toggle/Request Button
                          Row( 
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 2.1 Status Icons (Dine-in/Delivery)
                              Obx(() => StatusTag( 
                                isOpen: isOpen.value, 
                                hasDelivery: hasDelivery, 
                                hasDineIn: hasDineIn, 
                                iconSize: 20, 
                                showOpenStatus: false // <<< FIX: ไม่แสดงสถานะเปิด/ปิด
                              )),
                              
                              const SizedBox(width: 8), // Spacing between icons and switch/button

                              // 2.2 Action: Switch or Request Button
                              isSuspended 
                                ? // ถ้าถูกระงับ: แสดงปุ่มขออนุมัติซ้ำ
                                  SizedBox(
                                    width: 140, // กำหนดความกว้างให้ปุ่ม
                                    height: 35,
                                    child: ElevatedButton(
                                      onPressed: () => myShopController.requestReapproval(shopId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade700,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      ),
                                      child: const Text('ขออนุมัติซ้ำ', style: TextStyle(fontSize: 12, color: Colors.white)),
                                    ),
                                  )
                                : // ถ้าปกติ: แสดง Switch เปิด/ปิด
                                  Obx(() => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text( isOpen.value ? "เปิด" : "ปิด", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: isOpen.value ? Colors.green : Colors.red,)),
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Switch.adaptive(
                                            value: isOpen.value,
                                            onChanged: (newValue) {
                                              myShopController.toggleShopStatus(shopId, newValue); 
                                            },
                                            activeColor: Colors.green, inactiveThumbColor: Colors.red, inactiveTrackColor: Colors.red.shade100,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      
    );
  }
}