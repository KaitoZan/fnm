// lib/app/ui/pages/my_shop_page/widgets/my_shop_request_card.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/model/my_request_status.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // <<< 1. Import Get
import 'package:food_near_me_app/app/routes/app_routes.dart'; // <<< 2. Import AppRoutes

class MyShopRequestCard extends StatelessWidget {
  final MyRequestStatus request;

  const MyShopRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    
    // <<< 3. ตรรกะสำหรับ onTap (แก้ไข) ---
    // (อนุญาตให้กดดูได้ ถ้าเป็น Restaurant Edit)
    final bool canViewDetails = request.type == RequestType.restaurantEdit;
    
    final VoidCallback? onTapAction = canViewDetails ? () {
        // นำทางไปหน้า Resubmit/View (ส่ง ID ของตาราง 'restaurant_edits')
        Get.toNamed(
          AppRoutes.RESUBMITREQUEST + '/${request.id}',
          parameters: {'requestEditId': request.id.toString()},
        );
    } : null;
    // <<< สิ้นสุดการแก้ไขตรรกะ ---


    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: request.statusColor.withOpacity(0.5), width: 1),
      ),
      // <<< 4. ใช้ InkWell (ถ้ากดได้) ---
      child: InkWell(
        onTap: onTapAction, // <<< 5. ใส่ action (จะเป็น null ถ้าเป็น Complaint)
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(request.icon, color: request.statusColor, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      request.title, // (Title อัปเดตมาจาก Model แล้ว)
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: request.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      request.statusText,
                      style: TextStyle(
                        color: request.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              Text(
                request.details, // (Details อัปเดตมาจาก Model แล้ว)
                style: GoogleFonts.kanit(fontSize: 14, color: Colors.grey[700]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              // (แสดงเหตุผลที่ถูกปฏิเสธ - เหมือนเดิม)
              if (request.rejectionReason != null && request.rejectionReason!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "เหตุผลจาก Admin: ${request.rejectionReason}",
                  style: GoogleFonts.kanit(fontSize: 14, color: Colors.red[700], fontStyle: FontStyle.italic),
                ),
              ],
              
              // <<< 6. เพิ่ม "คำแนะนำ" (แก้ไข) ---
              if (canViewDetails) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      // (เปลี่ยนข้อความตามสถานะ)
                      request.status == RequestStatus.rejected 
                        ? 'แตะเพื่อแก้ไขและส่งคำร้องอีกครั้ง'
                        : 'แตะเพื่อดูรายละเอียดคำร้อง', 
                      style: TextStyle(
                        fontSize: 13, 
                        color: Colors.blue.shade700, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
              ],
              // <<< สิ้นสุดการแก้ไขข้อความ ---

              const SizedBox(height: 10),
              // (Date - เหมือนเดิม)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "วันที่ส่ง: ${request.formattedDate}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}