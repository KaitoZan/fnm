import 'package:get/get.dart';

import '../ui/pages/login_page/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LoginController>(() => LoginController());
    // Get.put<LoginController>(LoginController());
    // ใน InitialBinding หรือเมื่อแอปฯ เริ่มทำงาน
// Get.put(LoginController(), permanent: true); 
  }
}
