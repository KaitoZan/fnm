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
  
  // <<<--- [TASK 17.1 - เริ่มแก้ไข] ---
  // final bool showMotorcycleIcon; // (ลบ)
  final bool hasDelivery; // (เพิ่ม)
  final bool hasDineIn; // (เพิ่ม)
  // <<<--- [สิ้นสุดการแก้ไข] ---
  
  final VoidCallback? onTap;
  // --- เปลี่ยน shopId เป็น String (UUID) ---
  final String shopId; // <<<--- แก้ไข Type เป็น String

  const MyShopCard({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.description,
    this.rating = 0.0,
    required this.isOpen,
    // this.showMotorcycleIcon = false, // <<<--- [TASK 17.1 - แก้ไข] (ลบ)
    required this.hasDelivery, // (เพิ่ม)
    required this.hasDineIn, // (เพิ่ม)
    this.onTap,
    required this.shopId, // <<<--- รับ String
  });

  @override
  Widget build(BuildContext context) {
    final MyShopController myShopController = Get.find<MyShopController>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
          onTap: onTap, // Callback ที่ส่งมาจาก Showshopcard
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
                          StarRating( rating: rating, size: 10, onRatingChanged: (newRating) {} ),
                          
                          // <<<--- [TASK 17.1 - เริ่มแก้ไข] ---
                          // (แก้ไขการเรียก StatusTag)
                          Obx(() => StatusTag( 
                            isOpen: isOpen.value, 
                            // showMotorcycleIcon: showMotorcycleIcon, // (ลบ)
                            hasDelivery: hasDelivery, // (เพิ่ม)
                            hasDineIn: hasDineIn, // (เพิ่ม)
                            iconSize: 16, 
                            showOpenStatus: false
                          )),
                          // <<<--- [TASK 17.1 - สิ้นสุดการแก้ไข] ---
                          
                          // --- ส่วน Switch เปิด/ปิดร้าน ---
                          Obx(() => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text( isOpen.value ? "เปิด" : "ปิด", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: isOpen.value ? Colors.green : Colors.red,)),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch.adaptive(
                                    value: isOpen.value,
                                    onChanged: (newValue) {
                                      // --- ส่ง shopId (String) ไปที่ Controller ---
                                      myShopController.toggleShopStatus(shopId, newValue); // <<<--- ส่ง String ID
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}