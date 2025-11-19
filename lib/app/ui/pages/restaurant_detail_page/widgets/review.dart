// lib/app/ui/pages/restaurant_detail_page/widgets/review.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        Dotline(
          gradientColors: LinearGradient(colors: [Colors.blue.shade200, Colors.pink.shade200]),
          height: 4, dashWidth: 6,
        ),
        
        const SizedBox(height: 20),

        // ==========================================
        // PART 1: ส่วนให้คะแนนร้าน (Rating Section)
        // ==========================================
        Obx(() {
          final restaurant = controller.restaurant.value;
          final bool isOwner = loginController.isLoggedIn.value && 
                               restaurant != null && 
                               restaurant.ownerId == loginController.userId.value;
          
          if (isOwner) {
             return const SizedBox.shrink(); 
          }
          
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
              border: Border.all(color: Colors.amber.shade100),
            ),
            child: Column(
              children: [
                Text("ให้คะแนนร้านนี้", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Obx(() => controller.isRatingLoading.value 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : StarRating(
                      rating: controller.myRating.value, 
                      size: 40,
                      onRatingChanged: (value) {
                        controller.submitRating(value);
                      },
                    )
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                  controller.myRating.value > 0 ? "คะแนนของคุณ: ${controller.myRating.value.toInt()} ดาว" : "แตะที่ดาวเพื่อให้คะแนน",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                )),
              ],
            ),
          );
        }),

        const SizedBox(height: 30),
        
        // ==========================================
        // PART 2: รายการข้อความพูดคุย (Comments List)
        // ==========================================
        Text(
          "พูดคุย / สอบถาม",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[700]),
        ),
        const SizedBox(height: 15),

        // [แก้ไข 1] กำหนดความสูงแน่นอน (Fixed Height)
        Container(
          height: 400, // <<< กำหนดความสูงตายตัวไปเลยตามที่ขอ
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() {
             if (controller.isLoadingComments.value) {
               return const Center(child: CircularProgressIndicator());
             }
             if (controller.comments.isEmpty) {
               return const Center(
                 child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 20.0),
                   child: Text(
                     "ยังไม่มีข้อความพูดคุย\nเริ่มต้นเป็นคนแรกเลย!",
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.grey),
                   ),
                 ),
               );
             }
             
             return ListView.separated(
               shrinkWrap: true,
               physics: const AlwaysScrollableScrollPhysics(),
               itemCount: controller.comments.length,
               separatorBuilder: (_, __) => const SizedBox(height: 10),
               itemBuilder: (context, index) {
                 final comment = controller.comments[index];
                 final bool isMe = loginController.isLoggedIn.value && 
                                   loginController.userId.value == comment.userId;

                 // เรียกใช้ Widget แยกที่เราสร้างใหม่ด้านล่าง
                 return CommentItem(
                   comment: comment,
                   isMe: isMe,
                   controller: controller,
                 );
               },
             );
          }),
        ),

        const SizedBox(height: 30),

        // ==========================================
        // PART 3: กล่องเขียนข้อความ (Comment Input Box)
        // ==========================================
        Text(
          "เขียนข้อความถึงร้าน",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.commentController,
          maxLines: 4, 
          decoration: InputDecoration(
            hintText: "สอบถามรสชาติ, เมนูแนะนำ หรือพูดคุยกับร้าน...",
            border: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(15.0),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: ElevatedButton.icon(
            onPressed: controller.submitComment,
            icon: const Icon(Icons.send, size: 18),
            label: Text(
              "ส่งข้อความ",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 50),
      ],
    );
  }
}

// =========================================================
// [สร้างใหม่] Widget สำหรับแสดงแต่ละคอมเมนต์ เพื่อจัดการ State "ดูเพิ่มเติม"
// =========================================================
class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final bool isMe;
  final RestaurantDetailController controller;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isMe,
    required this.controller,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isExpanded = false; // สถานะว่ากดขยายหรือยัง

  @override
  Widget build(BuildContext context) {
    return Align(
      // [แก้ไข 2.1] จัดตำแหน่ง: ถ้าเป็นเราชิดขวา (หรือซ้ายก็ได้แล้วแต่ดีไซน์) แต่ใช้ Align เพื่อไม่ให้ยืดเต็มจอ
      // ในที่นี้ขอใช้ centerLeft เพื่อให้อ่านง่ายเหมือนเดิม แต่กรอบจะหดตามข้อความ
      alignment: Alignment.centerLeft, 
      child: Container(
        padding: const EdgeInsets.all(12),
        // [แก้ไข 2.2] กำหนด max-width เพื่อไม่ให้กว้างจนเกินไป (เช่น 80% ของจอ)
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ให้สูงเท่าเนื้อหา
          children: [
            // --- ส่วนหัว (Avatar + ชื่อ + ปุ่มลบ/report) ---
            Row(
              mainAxisSize: MainAxisSize.min, // ให้ Row กว้างเท่าเนื้อหาข้างใน
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: (widget.comment.userAvatarUrl != null && widget.comment.userAvatarUrl!.isNotEmpty)
                      ? CachedNetworkImageProvider(widget.comment.userAvatarUrl!) 
                      : null,
                  child: (widget.comment.userAvatarUrl == null || widget.comment.userAvatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 20, color: Colors.white) : null,
                ),
                const SizedBox(width: 10),
                Flexible( // ใช้ Flexible เพื่อให้ชื่อไม่ดันจนล้นถ้ากรอบแคบ
                  child: Text(
                    widget.comment.userName, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(width: 8),

                if (!widget.isMe)
                  InkWell(
                    onTap: () => widget.controller.showReportDialog(widget.comment.id),
                    child: Icon(Icons.flag_outlined, color: Colors.grey.shade400, size: 18),
                  ),

                if (widget.isMe) 
                  InkWell(
                    onTap: () => widget.controller.deleteComment(widget.comment.id),
                    child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 18),
                  ),
              ],
            ),
            
            // [แก้ไข 3] ลดระยะห่างระหว่างชื่อกับข้อความ (จาก 8 เหลือ 2-4)
            const SizedBox(height: 4),
            
            // --- ส่วนข้อความ และ ปุ่มดูเพิ่มเติม ---
            Padding(
              padding: const EdgeInsets.only(left: 0.0), // ไม่ต้อง Indent แล้ว เพราะอยู่ในกรอบเดียวกันสวยกว่า
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // สร้าง TextSpan เพื่อคำนวณบรรทัด
                  final span = TextSpan(
                    text: widget.comment.content,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  );
                  final tp = TextPainter(
                    text: span,
                    maxLines: 2, // เช็คที่ 2 บรรทัด
                    textDirection: TextDirection.ltr,
                  );
                  tp.layout(maxWidth: constraints.maxWidth);
                  
                  // เช็คว่าข้อความยาวเกิน 2 บรรทัดหรือไม่
                  final bool isOverflowing = tp.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.content,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        // ถ้ายังไม่กดขยาย ให้โชว์แค่ 2 บรรทัด
                        maxLines: isExpanded ? null : 2, 
                        overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                      
                      // [แก้ไข 2.3] ปุ่มดูเพิ่มเติม
                      if (isOverflowing && !isExpanded)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = true;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "ดูเพิ่มเติม...",
                              style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      
                      // (Optional) ปุ่มย่อน้อยลง ถ้าต้องการ
                      if (isExpanded && isOverflowing) 
                         GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "ย่อกลับ",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ),

                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.comment.createdAt.toLocal().toString().substring(0, 16), 
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}