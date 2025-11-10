// lib/app/ui/pages/my_shop_page/widgets/my_shop_request_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../my_shop_controller.dart';
import 'my_shop_request_card.dart';

class MyShopRequestList extends StatelessWidget {
  const MyShopRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    final MyShopController controller = Get.find<MyShopController>();

    return Obx(() {
      // 1. แสดง Loading
      if (controller.isLoadingRequests.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      // 2. แสดง "ไม่พบข้อมูล"
      if (controller.myRequestList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'คุณยังไม่มีคำร้องที่ส่งไป',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      // <<<--- [TASK 15 - เริ่มแก้ไข] ---
      // เป็น ListView.builder
      return ListView.builder(
        itemCount: controller.myRequestList.length,
        
        // <<< [สำคัญ] เพิ่มบรรทัดนี้
        physics: const NeverScrollableScrollPhysics(), 
        
        shrinkWrap: true, // <<< [สำคัญ]
        itemBuilder: (context, index) {
          final request = controller.myRequestList[index];
          // เพิ่ม Padding ด้านล่างสำหรับ item สุดท้าย
          if (index == controller.myRequestList.length - 1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: MyShopRequestCard(key: ValueKey(request.id), request: request),
            );
          }
          return MyShopRequestCard(key: ValueKey(request.id), request: request);
        },
      );
      // <<<--- [TASK 15 - สิ้นสุดการแก้ไข] ---
    });
  }
}