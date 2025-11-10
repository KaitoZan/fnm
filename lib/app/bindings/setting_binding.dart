



import 'package:food_near_me_app/app/ui/pages/setting_page/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
    
    
  }
}
