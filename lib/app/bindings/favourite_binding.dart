import 'package:food_near_me_app/app/ui/pages/favourite_page/favourite_controller.dart';
import 'package:get/get.dart';
// --- เพิ่ม import ---
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';

class FavouriteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavouriteController>(() => FavouriteController());
    // // --- เพิ่ม Scroll Controller สำหรับ Favourite ---
    //  Get.lazyPut<ScrollpageController>(
    //     () => ScrollpageController(),
    //     tag: 'favorite_scroll',
    //     fenix: true // ใช้ fenix เพื่อรักษา state การ scroll
    // );
  }
}
