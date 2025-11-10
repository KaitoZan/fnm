// lib/app/bindings/resubmit_request_binding.dart
import 'package:get/get.dart';

import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';
import '../ui/pages/resubmit_request_page/resubmit_request_controller.dart';

class ResubmitRequestBinding implements Bindings {
  @override
  void dependencies() {
    // ดึง requestEditId (id จากตาราง restaurant_edits)
    final String requestEditId = Get.parameters['requestEditId'] ?? '';
    
    // <<<--- 2. สร้าง Controller ใหม่ (ใช้ int.tryParse)
    Get.lazyPut<ResubmitRequestController>(
      () => ResubmitRequestController(
        requestEditId: int.tryParse(requestEditId) ?? 0,
      ),
      tag: requestEditId, // <<<--- 3. ใช้ ID (String) เป็น Tag
    );

    // สร้าง Scroll Controller พร้อม tag เฉพาะ
    Get.lazyPut<ScrollpageController>(
      () => ScrollpageController(),
      tag: 'resubmit_scroll_$requestEditId', // Tag สำหรับ scroll
    );
  }
}