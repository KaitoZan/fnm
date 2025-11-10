import 'package:food_near_me_app/app/ui/pages/my_profile_page/my_profile_controller.dart';
import 'package:get/get.dart';

class MyProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProfileController>(() => MyProfileController());
    // Get.put<MyProfileController>(MyProfileController());
  }
}
