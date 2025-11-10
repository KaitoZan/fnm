


import 'package:food_near_me_app/app/ui/pages/register_page/register_controller.dart';
import 'package:get/get.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    
    
  }
}
