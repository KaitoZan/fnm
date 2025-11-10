





import 'package:food_near_me_app/app/ui/pages/terms_conditions_page/terms_conditions_controller.dart';
import 'package:get/get.dart';

class TermsConditionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionsController>(() => TermsConditionsController());
    
    
  }
}
