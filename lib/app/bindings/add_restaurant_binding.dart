// lib/app/bindings/add_restaurant_binding.dart

import 'package:get/get.dart';
import '../ui/pages/add_restaurant_page/add_restaurant_controller.dart';
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';

class AddRestaurantBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRestaurantController>(() => AddRestaurantController());

    // สร้าง Scroll Controller พร้อม tag เฉพาะสำหรับหน้านี้
    Get.lazyPut<ScrollpageController>(
      () => ScrollpageController(),
      tag: 'add_details_scroll', // Tag สำหรับ scroll controller
    );
  }
}