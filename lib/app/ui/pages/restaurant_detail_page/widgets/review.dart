// lib/app/ui/pages/restaurant_detail_page/widgets/review.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart'; // ใช้ DetailMenuCtrl

import '../../../global_widgets/dotline.dart';
import '../../../global_widgets/star_rating.dart';
import '../../login_page/login_controller.dart'; // <<<--- [เพิ่ม] Import LoginController
import '../restaurant_detail_controller.dart'; // Import Controller และ Model

class Review extends StatelessWidget {
  final String restaurantId;
  const Review({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final RestaurantDetailController controller =
        Get.find<RestaurantDetailController>(tag: restaurantId);
    final LoginController loginController = Get.find<LoginController>(); // <<<--- [เพิ่ม] Find LoginController

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
            // textAlign: TextAlign.center, // อาจจะไม่ต้อง Center ก็ได้
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
          // จำกัดความสูงสูงสุด แต่ให้ปรับตามเนื้อหาได้
          constraints: const BoxConstraints(maxHeight: 400),
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.pink.shade50, // สีพื้นหลังอ่อนๆ
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() { // ใช้ Obx เพื่อติดตาม State reviews และ isLoadingReviews
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
                shrinkWrap: true, // ทำให้ ListView สูงตามเนื้อหา
                physics: const AlwaysScrollableScrollPhysics(), // ทำให้เลื่อนได้เสมอ
                itemCount: controller.reviews.length, // จำนวนรีวิว
                itemBuilder: (context, index) {
                  // ดึงข้อมูลรีวิว (CommentModel) จาก List
                  final review = controller.reviews[index];
                  
                  // --- [เพิ่ม] ตรวจสอบว่าเป็นเจ้าของคอมเมนต์หรือไม่ ---
                  final bool isOwner = loginController.isLoggedIn.value &&
                                      loginController.userId.value == review.userId;

                  return Card( // ใช้ Card เพื่อให้แต่ละรีวิวดูแยกกัน
                    margin: const EdgeInsets.only(bottom: 15.0),
                    elevation: 2, // เงาเล็กน้อย
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // ขอบมน
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row( // แถวสำหรับ Avatar, Username, ปุ่ม Report, Rating
                            crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่กลางแนวตั้ง
                            children: [
                              // แสดง Avatar
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey.shade300,
                                // ใช้ DetailMenuCtrl แสดง Avatar URL (ถ้ามี)
                                child: review.userAvatarUrl != null && review.userAvatarUrl!.isNotEmpty
                                      ? ClipOval(child: DetailMenuCtrl(imageUrl: review.userAvatarUrl!, fit: BoxFit.cover))
                                      : const Icon(Icons.person, color: Colors.white, size: 24), // ไอคอน Default
                              ),
                              const SizedBox(width: 10),
                              // แสดงชื่อผู้ใช้ (ขยายเต็มพื้นที่ที่เหลือ)
                              Expanded(
                                child: Text(
                                  review.userName, // ใช้ userName จาก Model
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis, // ตัดข้อความถ้าชื่อยาว
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8), // ระยะห่างก่อนปุ่ม Report
                              
                              // --- [แก้ไข] ปุ่ม Report (แสดงเมื่อ *ไม่ใช่* เจ้าของ) ---
                              if (!isOwner)
                                IconButton(
                                  icon: Icon(Icons.flag_outlined, color: Colors.grey.shade600, size: 20),
                                  padding: EdgeInsets.zero, // ไม่มี Padding เพิ่ม
                                  constraints: const BoxConstraints(), // ให้ปุ่มมีขนาดเล็กสุด
                                  tooltip: 'แจ้งปัญหาคอมเมนต์นี้', // ข้อความเมื่อกดค้าง
                                  onPressed: () {
                                     // เรียก showReportDialog จาก Controller พร้อมส่ง comment ID
                                     controller.showReportDialog(review.id);
                                  },
                                ),
                              
                              // --- [เพิ่ม] ปุ่ม Delete (แสดงเมื่อ *เป็น* เจ้าของ) ---
                              if (isOwner)
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'ลบคอมเมนต์นี้',
                                  onPressed: () {
                                     // เรียก deleteComment จาก Controller
                                     controller.deleteComment(review.id);
                                  },
                                ),

                              const SizedBox(width: 8), // ระยะห่างระหว่างปุ่มกับดาว
                              // แสดง Rating (ดาว)
                              StarRating(
                                  rating: review.ratingScore.toDouble(), // ใช้ ratingScore จาก Model
                                  size: 16 // ขนาดดาว
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0), // เพิ่มระยะห่าง
                          // แสดงเนื้อหาคอมเมนต์
                          Text(
                            review.content, // ใช้ content จาก Model
                            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                          ),
                          const SizedBox(height: 8.0),
                           // แสดงวันที่ (จัดชิดขวา)
                           Align(
                             alignment: Alignment.centerRight,
                             child: Text(
                                // Format วันที่ให้อ่านง่ายขึ้น (อาจจะต้อง import 'package:intl/intl.dart';)
                                // หรือแสดงแบบง่ายๆ ไปก่อน
                                review.createdAt.toLocal().toString().substring(0, 16), // เช่น 2023-10-27 10:30
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
        // แถวสำหรับให้คะแนน (ดาว)
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Text("ให้คะแนน: ", style: TextStyle(fontSize: 16.0)),
              Obx( // ใช้ Obx เพื่อให้ดาวอัปเดตเมื่อ userRating เปลี่ยน
                () => StarRating(
                  rating: controller.userRating.value, // ค่าคะแนนปัจจุบัน
                  size: 24, // ขนาดดาวใหญ่ขึ้น
                  onRatingChanged: controller.onRatingChanged, // Callback เมื่อกดดาว
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        // ช่องกรอกคอมเมนต์
        TextField(
          controller: controller.commentController, // Controller จาก RestaurantDetailController
          maxLines: 4, // หลายบรรทัด
          decoration: InputDecoration(
            hintText: "เขียนความคิดเห็นของคุณที่นี่...",
            border: OutlineInputBorder( // กรอบสี่เหลี่ยม
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder( // กรอบตอน Focus
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(15.0), // ระยะห่างข้างใน
          ),
        ),
        const SizedBox(height: 20.0),
        // ปุ่มส่งรีวิว
        Center(
          child: ElevatedButton(
            onPressed: controller.submitReview, // เรียกฟังก์ชัน submitReview ใน Controller
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400], // สีปุ่ม
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // ขนาดปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // ปุ่มขอบมน
              ),
            ),
            child: Text(
              "ส่งรีวิว",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // สีตัวอักษร
              ),
            ),
          ),
        ),
      ],
    );
  }
}