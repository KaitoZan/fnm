// lib/app/ui/pages/home_page/widgets/home_restaurant_card.dart
import 'package:flutter/material.dart';
// ใช้ DetailMenuCtrl เพื่อความสะดวกในการจัดการ Error/Loading
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart';
import 'package:get/get.dart';

import '../../../global_widgets/star_rating.dart';
import '../../../global_widgets/status_tag.dart';

class HomeRestaurantCard extends StatelessWidget {
  // imageUrl ตอนนี้คาดหวังว่าจะเป็น URL (หรือ null/empty)
  final String? imageUrl;
  final String restaurantName;
  final String description;
  final double rating;
  // isOpen ตอนนี้มาจาก Model ที่เป็น RxBool
  final RxBool isOpen;
  final bool showMotorcycleIcon;
  final VoidCallback? onTap;
  final double? distanceInMeters; // <<<--- [เพิ่ม] รับค่าระยะทาง

  const HomeRestaurantCard({
    super.key,
    required this.imageUrl, // อาจจะเป็น null ได้
    required this.restaurantName,
    required this.description,
    this.rating = 0.0,
    required this.isOpen, // รับ RxBool
    this.showMotorcycleIcon = false,
    this.onTap,
    this.distanceInMeters, // <<<--- [เพิ่ม]
  });

  @override
  Widget build(BuildContext context) {
    
    // --- [เพิ่ม] ตรวจสอบว่ามีค่าระยะทางที่ใช้งานได้หรือไม่ ---
    final bool hasDistance = distanceInMeters != null &&
        distanceInMeters != double.maxFinite;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect( // ใช้ ClipRRect ตัดขอบรูป
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200], // สีพื้นหลังเผื่อรูปโหลดไม่ได้
                    // --- ใช้ DetailMenuCtrl แสดงรูป ---
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? DetailMenuCtrl(imageUrl: imageUrl!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.storefront, color: Colors.grey)), // Icon Placeholder
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1, // ป้องกันชื่อยาวเกินไป
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        description,
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                        maxLines: 3, // จำกัด 3 บรรทัด
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StarRating(
                            rating: rating,
                            size: 10,
                            onRatingChanged: (newRating) {},
                          ),
                          
                          // --- [แก้ไข] จัดกลุ่มระยะทางและสถานะไว้ด้วยกัน ---
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- [เพิ่ม] Widget แสดงระยะทาง (km) ---
                              if (hasDistance)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Text(
                                    // แปลงเมตรเป็นกิโลเมตร
                                    "${(distanceInMeters! / 1000).toStringAsFixed(1)} km", 
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              
                              // --- Widget StatusTag (เหมือนเดิม) ---
                              Obx(() => StatusTag(
                                // อ่านค่า .value จาก RxBool
                                isOpen: isOpen.value,
                                showMotorcycleIcon: showMotorcycleIcon,
                                fontSize: 12,
                              )),
                            ],
                          )
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