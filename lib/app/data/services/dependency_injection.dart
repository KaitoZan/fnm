// lib/app/data/services/dependency_injection.dart
import 'package:get/get.dart';

// --- Import Controllers และ Services ---
import '../../ui/global_widgets/filter_ctrl.dart';
// --- [แก้ไข] ชื่อไฟล์ที่ถูกต้องคือ slide_ctrl.dart ---
import '../../ui/global_widgets/slide_ctrl.dart'; 
import '../../ui/layouts/main/main_controller.dart';
import '../../ui/pages/login_page/login_controller.dart';
import '../../ui/pages/navbar_page/navbar_controller.dart';
import '../../ui/pages/restaurant_detail_page/widgets/scrollctrl.dart';
import '../../ui/pages/my_shop_page/my_shop_controller.dart';
import 'location_service.dart';

// --- [แก้ไข] เปลี่ยนกลับเป็น class ธรรมดา ---
class DependencyInjection {
  // --- [แก้ไข] สร้าง static method 'init' ---
  static void init() {
    // App Core
    Get.put<MainController>(MainController());

    // --- [แก้ไข] เรียงลำดับการสร้างใหม่ ---

    // 1. สร้าง Services/Controllers หลัก (ที่ตัวอื่นต้องใช้) ก่อน
    Get.lazyPut(() => LocationService(), fenix: true); // <<<--- ย้ายขึ้นมา
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => NavbarController(), fenix: true);

    // 2. สร้าง Controllers ที่ต้องพึ่งพาตัวบน
    // (FilterController ต้องใช้ LocationService และ LoginController)
    Get.lazyPut(() => FilterController(), fenix: true); 
    
    // (MyShopController ต้องใช้ LoginController และ FilterController)
    Get.lazyPut(() => MyShopController(), fenix: true);
    
    // 3. สร้าง Controllers ที่เหลือ
    // (SlideController ต้องใช้ FilterController)
    Get.lazyPut(() => SlideController(), fenix: true); 

    // 4. Scroll Controllers (ไม่ขึ้นอยู่กับใคร)
    Get.lazyPut(() => ScrollpageController(), tag: 'home_scroll', fenix: true);
    Get.lazyPut(() => ScrollpageController(), tag: 'favorite_scroll', fenix: true);
    Get.lazyPut(() => ScrollpageController(), tag: 'myshop_scroll', fenix: true);
    // --- [สิ้นสุดการแก้ไข] ---
  }
}