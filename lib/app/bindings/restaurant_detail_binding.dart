import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/restaurant_detail_controller.dart';
import 'package:get/get.dart';
// --- เพิ่ม import ---
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';

class RestaurantDetailBinding implements Bindings {
  @override
  void dependencies() {
    // ดึง restaurantId จาก parameters
    final String restaurantId = Get.parameters['restaurantId'] ?? '';

    // ใช้ lazyPut เพื่อสร้าง Controller เมื่อจำเป็น และใช้ tag
    Get.lazyPut<RestaurantDetailController>(
      () => RestaurantDetailController(restaurantId: restaurantId),
      tag: restaurantId, // ใช้ restaurantId เป็น tag
    );

    // สร้าง Scroll Controller พร้อม tag เฉพาะสำหรับหน้านี้
    Get.lazyPut<ScrollpageController>(
      () => ScrollpageController(),
      tag: 'detail_scroll_$restaurantId', // Tag สำหรับ scroll controller
    );
  }
}
