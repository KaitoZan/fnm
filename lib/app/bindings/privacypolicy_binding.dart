
import 'package:food_near_me_app/app/ui/pages/privacypolicy_page/privacypolicy_controller.dart';
import 'package:get/get.dart';

class PrivacypolicyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacypolicyController>(() => PrivacypolicyController());
   
  }
}
