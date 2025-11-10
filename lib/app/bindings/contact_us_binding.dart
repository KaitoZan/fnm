
import 'package:food_near_me_app/app/ui/pages/contact_us_page/contact_us_controller.dart';
import 'package:get/get.dart';

class ContactUsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
    // Get.put<ContactUsController>(ContactUsController());
  }
}
