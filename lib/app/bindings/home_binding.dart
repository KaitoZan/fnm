// lib/app/bindings/home_binding.dart
import 'package:food_near_me_app/app/ui/pages/home_page/home_controller.dart';
import 'package:get/get.dart';
// --- เพิ่ม import ---
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // // --- เพิ่ม Scroll Controller สำหรับ Home ที่นี่ ---
    // Get.lazyPut<ScrollpageController>(
    //     () => ScrollpageController(),
    //     tag: 'home_scroll', // <<<--- Tag สำหรับหน้านี้
    //     fenix: true // ใช้ fenix เพื่อรักษา state การ scroll เมื่อเปลี่ยน tab
    // );
  }
}