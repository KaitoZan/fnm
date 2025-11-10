import 'package:food_near_me_app/app/ui/pages/forgot_password_page/forgot_password_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    // --- เพิ่มการ put CheckboxController ที่นี่ ---
    // ใช้ Get.put แทน lazyPut เพราะ CheckboxController น่าจะ state ไม่ซับซ้อน และใช้แค่ในหน้านี้
    Get.put<CheckboxController>(CheckboxController());
  }
}
