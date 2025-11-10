// lib/app/ui/pages/edit_profile_page/widgets/edpf_profile_insert.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// <<<--- [TASK 12.3 - เพิ่ม] Import
import 'package:cached_network_image/cached_network_image.dart';

import '../edit_profile_controller.dart';

class EditProfileInsert extends StatelessWidget {
  const EditProfileInsert({super.key});

  @override
  Widget build(BuildContext context) {
    // คำนวณขนาดและตำแหน่ง
    final double appBarHeight = 96.0; // (มาจาก AppbarB.preferredSize.height)
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double profileCircleSize = 100.0;
    final EditProfileController editController = Get.find<EditProfileController>();

    return Positioned(
      left: 0,
      right: 0,
      // คำนวณตำแหน่ง Top
      top: statusBarHeight + appBarHeight - (profileCircleSize / 1.2),
      child: Align(
        alignment: Alignment.center,
        child: InkWell( // ทำให้กดเลือกรูปได้
          onTap: () => editController.pickProfileImage(), // เรียกฟังก์ชันเลือกรูป
          borderRadius: BorderRadius.circular(profileCircleSize / 2), // ขอบเขตการกด
          child: Obx(() { // ใช้ Obx เพื่อให้ UI อัปเดตตาม State
            
            final String imgUrlOrPath = editController.imgProfileImageUrl.value;
            Widget imageWidget;

            // Logic การแสดงผลรูปภาพ
            if (imgUrlOrPath.startsWith('http')) {
              // <<<--- [TASK 12.3 - เริ่มแก้ไข] ---
              // (ลบ Image.network)
              // imageWidget = Image.network(
              //   imgUrlOrPath,
              //   width: profileCircleSize,
              //   height: profileCircleSize,
              //   fit: BoxFit.cover, 
              //   loadingBuilder: (context, child, loadingProgress) {
              //     ...
              //   },
              //   errorBuilder: (context, error, stackTrace) =>
              //       Image.asset(
              //         'assets/ics/person.png', 
              //         ...
              //       ),
              // );

              // (ใช้ CachedNetworkImage แทน)
              imageWidget = CachedNetworkImage(
                imageUrl: imgUrlOrPath,
                width: profileCircleSize,
                height: profileCircleSize,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/ics/person.png',
                  width: profileCircleSize,
                  height: profileCircleSize,
                  fit: BoxFit.cover
                ),
              );
              // <<<--- [TASK 12.3 - สิ้นสุดการแก้ไข] ---

            } else if (imgUrlOrPath.startsWith('assets/')) {
               // ถ้าเป็น Asset (ค่าเริ่มต้น)
               imageWidget = Image.asset(
                 imgUrlOrPath, 
                 width: profileCircleSize,
                 height: profileCircleSize,
                 fit: BoxFit.cover
                );
            } else if (File(imgUrlOrPath).existsSync()) {
              // ถ้าเป็น Path ใหม่ที่เพิ่งเลือก
              imageWidget = Image.file(
                File(imgUrlOrPath),
                width: profileCircleSize,
                height: profileCircleSize,
                fit: BoxFit.cover, 
              );
            } else {
              // กรณีอื่นๆ (เช่น ค่าว่าง)
              imageWidget = Image.asset(
                'assets/ics/person.png', 
                width: profileCircleSize,
                height: profileCircleSize,
                fit: BoxFit.cover
              );
            }

            // --- Container และ Stack แสดงผล (เหมือนเดิม) ---
            return Container(
              width: profileCircleSize,
              height: profileCircleSize,
              decoration: BoxDecoration(
                 shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // เงา
                        ),
                      ],
                    ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(child: imageWidget), // แสดงรูป
                  // ไอคอนกล้อง
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink[400],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}