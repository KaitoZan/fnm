

import 'package:food_near_me_app/app/ui/pages/reset_password_page/reset_password_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
   
  }
}
