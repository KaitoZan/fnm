import 'package:food_near_me_app/app/ui/pages/edit_profile_page/edit_profile_controller.dart';
import 'package:get/get.dart';
// --- เพิ่ม import ---
import '../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());

    // --- ย้าย Get.lazyPut Scroll Controller มาไว้ที่นี่ ---
    Get.lazyPut<ScrollpageController>(
      () => ScrollpageController(),
      tag: 'edit_profile_scroll', // ใช้ tag เดิม
    );
  }
}
