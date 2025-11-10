// lib/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart
import 'dart:io';
import 'package:flutter/material.dart';
// <<<--- [TASK 12.3 - เพิ่ม] Import
import 'package:cached_network_image/cached_network_image.dart';

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
      
      // <<<--- [TASK 12.3 - เริ่มแก้ไข] ---
      // (ลบ Image.network)
      // return Image.network(
      //   imageUrl,
      //   fit: fit,
      //   loadingBuilder: (context, child, loadingProgress) {
      //     ...
      //   },
      //   errorBuilder: (context, error, stackTrace) {
      //     ...
      //   }
      // );
      
      // (ใช้ CachedNetworkImage แทน)
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        // (แสดงสถานะกำลังโหลด)
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2, 
            color: Colors.pink.shade200, 
          ),
        ),
        // (แสดง Placeholder ถ้าโหลดไม่ได้)
        errorWidget: (context, url, error) {
          print("Error loading image: $imageUrl, Error: $error"); // แสดง Error ใน Console
          return Container( // แสดง Container สีเทาพร้อมไอคอนแทน
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          );
        },
      );
      // <<<--- [TASK 12.3 - สิ้นสุดการแก้ไข] ---

    }
    // --- โค้ดเดิมสำหรับ Asset และ File (เหมือนเดิม) ---
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
      ),
    );
  }
}