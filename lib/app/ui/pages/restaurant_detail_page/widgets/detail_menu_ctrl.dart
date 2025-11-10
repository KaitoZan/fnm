// lib/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart
import 'dart:io';
import 'package:flutter/material.dart';

class DetailMenuCtrl extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const DetailMenuCtrl({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover, // กำหนดค่าเริ่มต้นให้ fit
  });

  @override
  Widget build(BuildContext context) {
    // --- ตรวจสอบว่าเป็น URL หรือไม่ ---
    if (imageUrl.startsWith('http')) {
      // --- ถ้าเป็น URL จากอินเทอร์เน็ต (Supabase) ---
      return Image.network(
        imageUrl,
        fit: fit,
        // เพิ่ม Loading Builder เพื่อแสดงสถานะกำลังโหลด
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child; // โหลดเสร็จแล้ว แสดงรูปภาพ
          return Center(
            child: CircularProgressIndicator(
              // คำนวณ % การโหลด (ถ้าต้องการ)
              // value: loadingProgress.expectedTotalBytes != null
              //     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              //     : null,
              strokeWidth: 2, // ขนาดเส้นเล็กลง
              color: Colors.pink.shade200, // สี Loading
            ),
          );
        },
        // เพิ่ม Error Builder เพื่อแสดง Placeholder ถ้าโหลดไม่ได้
        errorBuilder: (context, error, stackTrace) {
           print("Error loading image: $imageUrl, Error: $error"); // แสดง Error ใน Console
           return Container( // แสดง Container สีเทาพร้อมไอคอนแทน
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
           );
        }
      );
    }
    // --- โค้ดเดิมสำหรับ Asset และ File (อาจจะไม่ค่อยได้ใช้แล้ว แต่เก็บไว้เผื่อ) ---
    else if (imageUrl.startsWith('assets/')) {
      // กรณีเป็นไฟล์ asset
      return Image.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else if (File(imageUrl).existsSync()) {
      // กรณีเป็นไฟล์ในเครื่อง
      return Image.file(
        File(imageUrl),
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
    // --- กรณีเป็นค่าว่าง หรือ Path/URL รูปแบบอื่นๆ ที่ไม่รู้จัก ---
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.image_not_supported, color: Colors.grey[600]), // แสดงไอคอนแทน Text
        // child: Text(
        //   imageUrl.isNotEmpty ? 'Invalid Path/URL' : 'No Image',
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(color: Colors.black54, fontSize: 10),
        // ),
      ),
    );
  }
}