import 'package:food_near_me_app/app/ui/pages/aboutapp_page/aboutapp_controller.dart';
import 'package:get/get.dart';

class AboutappBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutappController>(() => AboutappController());
    // Get.put<AboutappController>(AboutappController());
  }
}
