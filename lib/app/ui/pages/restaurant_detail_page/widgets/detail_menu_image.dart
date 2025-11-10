// lib/app/ui/pages/restaurant_detail_page/widgets/detail_menu_image.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ใช้ DetailMenuCtrl เหมือนเดิม เพราะมันรองรับ URL อยู่แล้ว
import 'detail_menu_ctrl.dart';

class DetailMenuImage extends StatelessWidget {
  // รับ List<String> ที่อาจจะเป็น URL
  final List<String> menuImages;

  const DetailMenuImage({super.key, required this.menuImages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "เมนูแนะนำ:",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10.0),

        menuImages.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "ไม่มีเมนูแนะนำ",
                    style: GoogleFonts.kanit(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : Container(
                height: 8 * 50, // ความสูงของ ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuImages.length,
                  itemBuilder: (context, index) {
                    final imageUrl = menuImages[index]; // imageUrl ตอนนี้เป็น URL จาก Supabase
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          width: 200, // กำหนดความกว้างของแต่ละรูป (ปรับได้)
                          // ใช้ DetailMenuCtrl แสดงผล URL
                          child: DetailMenuCtrl(imageUrl: imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),

        const SizedBox(height: 20), // ระยะห่างด้านล่าง
      ],
    );
  }
}