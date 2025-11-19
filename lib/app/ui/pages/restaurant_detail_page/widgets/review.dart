// lib.zip/app/ui/pages/restaurant_detail_page/widgets/review.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart'; // (ไม่จำเป็นต้องใช้ใน Widget นี้แล้ว)
// <<<--- [TASK 21 - 1. เพิ่ม] Import CachedNetworkImage
import 'package:cached_network_image/cached_network_image.dart';

import '../../../global_widgets/dotline.dart';
import '../../../global_widgets/star_rating.dart';
import '../../login_page/login_controller.dart'; 
import '../restaurant_detail_controller.dart'; 

class Review extends StatelessWidget {
  final String restaurantId;
  const Review({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final RestaurantDetailController controller =
        Get.find<RestaurantDetailController>(tag: restaurantId);
    final LoginController loginController = Get.find<LoginController>(); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- ส่วนหัว "รีวิวจากลูกค้า" และเส้นประ ---
        Dotline(
          gradientColors: LinearGradient(
            colors: [Colors.blue.shade200, Colors.pink.shade200],
          ),
          height: 4,
          dashWidth: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            "รีวิวจากลูกค้า",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink[700],
            ),
          ),
        ),
        Dotline(
          gradientColors: LinearGradient(
            colors: [Colors.blue.shade200, Colors.pink.shade200],
          ),
          height: 4,
          dashWidth: 6,
        ),
        const SizedBox(height: 20.0),

        // --- ส่วนแสดงผล List รีวิว ---
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.pink.shade50, 
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() { 
            // --- แสดง Loading Indicator ---
            if (controller.isLoadingReviews.value) {
              return const Center(child: CircularProgressIndicator());
            }
            // --- แสดงข้อความ "ยังไม่มีรีวิว" ---
            else if (controller.reviews.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "ยังไม่มีรีวิวสำหรับร้านนี้",
                    style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ),
              );
            }
            // --- แสดง ListView ของรีวิว ---
            else {
              return ListView.builder(
                shrinkWrap: true, 
                physics: const AlwaysScrollableScrollPhysics(), 
                itemCount: controller.reviews.length, 
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];
                  final bool isOwner = loginController.isLoggedIn.value &&
                                      loginController.userId.value == review.userId;

                  return Card( 
                    margin: const EdgeInsets.only(bottom: 15.0),
                    elevation: 2, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row( 
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              
                              // <<<--- [TASK 21 - 2. เริ่มแก้ไข] ---
                              // แสดง Avatar
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey.shade300,
                                
                                // (ลบ child: ... ClipOval(child: DetailMenuCtrl(...)) ... )
                                // child: review.userAvatarUrl != null && review.userAvatarUrl!.isNotEmpty
                                //       ? ClipOval(child: DetailMenuCtrl(imageUrl: review.userAvatarUrl!, fit: BoxFit.cover))
                                //       : const Icon(Icons.person, color: Colors.white, size: 24),

                                // (เพิ่ม backgroundImage แทน)
                                backgroundImage: (review.userAvatarUrl != null && review.userAvatarUrl!.isNotEmpty)
                                    // (ใช้ CachedNetworkImageProvider)
                                    ? CachedNetworkImageProvider(review.userAvatarUrl!) 
                                    : null, // (ถ้าเป็น null, backgroundColor จะทำงาน)
                                
                                // (เพิ่ม child: (สำหรับกรณีที่ไม่มีรูป)
                                child: (review.userAvatarUrl == null || review.userAvatarUrl!.isEmpty)
                                    ? const Icon(Icons.person, color: Colors.white, size: 24) // ไอคอน Default
                                    : null, // (ถ้ามีรูป, backgroundImage จะแสดง)
                              ),
                              // <<<--- [TASK 21 - 2. สิ้นสุดการแก้ไข] ---
                              
                              const SizedBox(width: 10),
                              // แสดงชื่อผู้ใช้ (ขยายเต็มพื้นที่ที่เหลือ)
                              Expanded(
                                child: Text(
                                  review.userName, // ใช้ userName จาก Model
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis, 
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8), 
                              
                              // (ปุ่ม Report - เหมือนเดิม)
                              if (!isOwner)
                                IconButton(
                                  icon: Icon(Icons.flag_outlined, color: Colors.grey.shade600, size: 20),
                                  padding: EdgeInsets.zero, 
                                  constraints: const BoxConstraints(), 
                                  tooltip: 'แจ้งปัญหาคอมเมนต์นี้', 
                                  onPressed: () {
                                     controller.showReportDialog(review.id);
                                  },
                                ),
                              
                              // (ปุ่ม Delete - เหมือนเดิม)
                              if (isOwner)
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'ลบคอมเมนต์นี้',
                                  onPressed: () {
                                     controller.deleteComment(review.id);
                                  },
                                ),

                              const SizedBox(width: 8), 
                              // (Rating (ดาว) - เหมือนเดิม)
                              StarRating(
                                  rating: review.ratingScore.toDouble(), 
                                  size: 16 
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0), 
                          // (เนื้อหาคอมเมนต์ - เหมือนเดิม)
                          Text(
                            review.content, 
                            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                          ),
                          const SizedBox(height: 8.0),
                           // (วันที่ - เหมือนเดิม)
                           Align(
                             alignment: Alignment.centerRight,
                             child: Text(
                                review.createdAt.toLocal().toString().substring(0, 16), 
                                style: const TextStyle(fontSize: 10.0, color: Colors.grey),
                             ),
                           ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ),
        const SizedBox(height: 30.0),

        // --- ส่วนเขียนรีวิว ---
        Text(
          "เขียนรีวิวของคุณ",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink[700],
          ),
        ),
        const SizedBox(height: 15.0),
        // (StarRating - เหมือนเดิม)
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Text("ให้คะแนน: ", style: TextStyle(fontSize: 16.0)),
              Obx( 
                () => StarRating(
                  rating: controller.userRating.value, 
                  size: 24, 
                  onRatingChanged: controller.onRatingChanged, 
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        // (TextField - เหมือนเดิม)
        TextField(
          controller: controller.commentController, 
          maxLines: 4, 
          decoration: InputDecoration(
            hintText: "เขียนความคิดเห็นของคุณที่นี่...",
            border: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(15.0), 
          ),
        ),
        const SizedBox(height: 20.0),
        // (ปุ่มส่งรีวิว - เหมือนเดิม)
        Center(
          child: ElevatedButton(
            onPressed: controller.submitReview, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400], 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), 
              ),
            ),
            child: Text(
              "ส่งรีวิว",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
          ),
        ),
      ],
    );
  }
}