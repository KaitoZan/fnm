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

      // 3. แสดง List
      return Column(
        children: [
          ...controller.myRequestList.map((request) {
            return MyShopRequestCard(key: ValueKey(request.id), request: request);
          }).toList(),
          const SizedBox(height: 80), // Padding ด้านล่างสุด (เผื่อ FAB)
        ],
      );
    });
  }
}