




import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_controller.dart';
import 'package:food_near_me_app/app/ui/pages/splash_page/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SplashController>(() => SplashController());
    // Get.put(SplashController());
    Get.put<SplashController>(SplashController());

    // Get.lazyPut<NavbarController>(() => NavbarController());
    
  }
}
