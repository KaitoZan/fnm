// lib/app/ui/pages/restaurant_detail_page/widgets/detail_promotion.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ใช้ DetailMenuCtrl สำหรับแสดงรูปภาพ URL
import 'detail_menu_ctrl.dart';

class Promotion extends StatelessWidget {
  // รับ List<String> ที่อาจจะเป็น URL หรือ Text
  const Promotion({super.key, required this.promotion});

  final List<String> promotion;

  @override
  Widget build(BuildContext context) {
    if (promotion.isEmpty) {
      return _buildEmptyState();
    }

    // --- ตรวจสอบว่าเป็น URL หรือ Text ---
    // (ถ้ามี item ไหนขึ้นต้นด้วย http ให้ถือว่าเป็นรูปภาพทั้งหมด)
    bool isImageBanner = promotion.any((item) => item.startsWith('http'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "โปรโมชั่น:",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10),

        // --- เลือก Widget ตามประเภท ---
        isImageBanner ? _buildImageBanners() : _buildTextBanners(),
        const SizedBox(height: 20), // เพิ่มระยะห่างด้านล่างเสมอ
      ],
    );
  }

  // Widget แสดงผลเมื่อไม่มีข้อมูล
  Widget _buildEmptyState() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
            "โปรโมชั่น:",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
            ),
            ),
            const SizedBox(height: 10),
            Center(
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                    "ไม่มีโปรโมชั่นในขณะนี้",
                    style: GoogleFonts.kanit(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    ),
                ),
                ),
            ),
             const SizedBox(height: 20), // เพิ่มระยะห่าง
        ],
    );
  }

  // Widget แสดงผลโปรโมชั่นแบบ "รูปภาพ" (ใช้ DetailMenuCtrl)
  Widget _buildImageBanners() {
    return SizedBox(
      height: 120, // ความสูงของ ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotion.length,
        itemBuilder: (context, index) {
          final imageUrl = promotion[index]; // imageUrl คือ URL จาก Supabase
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 300, // ความกว้างของรูปโปรโมชั่น (ปรับได้)
                // ใช้ DetailMenuCtrl แสดงผล URL
                child: DetailMenuCtrl(imageUrl: imageUrl, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget แสดงผลโปรโมชั่นแบบ "ข้อความ" (เหมือนเดิม)
  Widget _buildTextBanners() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.pink.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: promotion.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '• $text', // เพิ่ม bullet point ด้านหน้า
              style: GoogleFonts.kanit(fontSize: 14.0, color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }
}