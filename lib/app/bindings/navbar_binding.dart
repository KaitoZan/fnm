import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_controller.dart';
import 'package:get/get.dart';

import '../ui/pages/login_page/login_controller.dart';
import '../ui/pages/navbar_page/navbar_controller.dart';
// --- ไม่ต้อง import NavbarController ที่นี่แล้ว ---
// import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_controller.dart';

class NavbarBinding implements Bindings {
  @override
  void dependencies() {
    // --- ไม่ต้อง lazyPut NavbarController ที่นี่ เพราะจัดการใน DependencyInjection แล้ว ---
    // Get.lazyPut<NavbarController>(() => NavbarController());
    // Get.lazyPut<LoginController>(() => LoginController());
    // Get.lazyPut<MyShopController>(() => MyShopController());
  }
}
