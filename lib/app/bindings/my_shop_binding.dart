import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_controller.dart';
import 'package:get/get.dart';
// --- เพิ่ม import ---
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';


class MyShopBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MyShopController>(() => MyShopController());
    //  // --- เพิ่ม Scroll Controller สำหรับ MyShop ---
    //  Get.lazyPut<ScrollpageController>(
    //     () => ScrollpageController(),
    //     tag: 'myshop_scroll',
    //     fenix: true 
    // );
  }
}
