import 'package:get/get.dart';
// --- เพิ่ม imports ---
import '../ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_controller.dart';
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart'; // ใช้ Scroll Controller ตัวเดียวกัน

class EditRestaurantDetailBinding implements Bindings {
  @override
  void dependencies() {
    // ดึง restaurantId จาก parameters
    final String restaurantId = Get.parameters['restaurantId'] ?? '';

    // ใช้ lazyPut เพื่อสร้าง Controller เมื่อจำเป็น และใช้ tag
    Get.lazyPut<RestaurantEditDetailController>( // --- แก้ไขชื่อ Controller ---
      () => RestaurantEditDetailController(restaurantId: restaurantId), // --- แก้ไขชื่อ Controller ---
      tag: restaurantId, // ใช้ restaurantId เป็น tag
    );

    // สร้าง Scroll Controller พร้อม tag เฉพาะสำหรับหน้านี้
    Get.lazyPut<ScrollpageController>(
      () => ScrollpageController(),
      tag: 'edit_details_scroll_$restaurantId', // Tag สำหรับ scroll controller
    );
  }
}
