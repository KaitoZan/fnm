// lib/app/ui/pages/restaurant_detail_page/widgets/detail_menu_image.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:google_fonts/google_fonts.dart';

import '../../../../model/menu_item.dart';
import 'detail_menu_ctrl.dart';

class DetailMenuImage extends StatelessWidget {
  final List<String> galleryImages;
  final List<MenuItem> menuItems;

  const DetailMenuImage({
    super.key,
    required this.galleryImages,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    // (ส่วน build() ... เหมือนเดิม)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "แกลเลอรี / เมนู:", 
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10.0),

        Stack(
          children: [
            // --- ส่วนแสดงผลรูปภาพ (Gallery) ---
            galleryImages.isEmpty
                ? _buildPlaceholder() 
                : Container(
                    height: 8 * 50, 
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: galleryImages.length, 
                      itemBuilder: (context, index) {
                        final imageUrl = galleryImages[index]; 
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SizedBox(
                              width: 200, 
                              child: DetailMenuCtrl(imageUrl: imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            
            // --- ปุ่มเปิด Pop-up เมนู ---
            if (menuItems.isNotEmpty)
              Positioned(
                top: 8,
                right: 18, 
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5), 
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu_book_rounded, 
                      color: Colors.white,
                      size: 28,
                    ),
                    tooltip: 'เปิดรายการเมนู',
                    onPressed: () {
                      _showMenuPopup(context, menuItems);
                    },
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20), 
      ],
    );
  }

  // (Widget _buildPlaceholder() ... เหมือนเดิม)
  Widget _buildPlaceholder() {
    return Container(
      height: 8 * 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "ไม่มีรูปภาพแกลเลอรี",
            style: GoogleFonts.kanit(
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }


  // --- (แก้ไข) ฟังก์ชันแสดง Pop-up รายการเมนู (Text-based) ---
  void _showMenuPopup(BuildContext context, List<MenuItem> menuItems) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu_rounded, color: Colors.pink[700]),
            const SizedBox(width: 10),
            const Text("รายการเมนู"),
          ],
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        content: Container(
          width: Get.width * 0.8, 
          height: Get.height * 0.5, 
          child: menuItems.isEmpty
              ? const Center(child: Text("ไม่มีรายการเมนู (ข้อความ)"))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return ListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // <<<--- 1. ลบ Subtitle (Description)
                      // subtitle: (item.description.isNotEmpty)
                      //     ? Text(item.description)
                      //     : null,
                      
                      // <<<--- 2. แก้ไข Trailing (Price)
                      trailing: Text(
                        item.price > 0 ? "${item.price.toStringAsFixed(0)} ฿" : "N/A",
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("ปิด"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}