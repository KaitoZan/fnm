

import 'package:food_near_me_app/app/ui/pages/otp_page/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
    
  }
}
