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

    // --- [TASK 12.2 - เริ่มแก้ไข] ---
    // เปลี่ยน lazyPut เป็น put (สร้างทันที) สำหรับ Core Controllers
    
    // 1. สร้าง Services/Controllers หลัก (ที่ตัวอื่นต้องใช้) ก่อน
    Get.put(LocationService(), permanent: true); // <<<--- [แก้ไข]
    Get.put(LoginController(), permanent: true); // <<<--- [แก้ไข]
    Get.put(NavbarController(), permanent: true); // <<<--- [แก้ไข]

    // 2. สร้าง Controllers ที่ต้องพึ่งพาตัวบน
    // (FilterController ต้องใช้ LocationService และ LoginController)
    Get.put(FilterController(), permanent: true); // <<<--- [แก้ไข]
    
    // (MyShopController ต้องใช้ LoginController และ FilterController)
    Get.put(MyShopController(), permanent: true); // <<<--- [แก้ไข]
    
    // 3. สร้าง Controllers ที่เหลือ (ยังเป็น lazyPut ได้)
    // (SlideController ต้องใช้ FilterController)
    Get.lazyPut(() => SlideController(), fenix: true); 

    // 4. Scroll Controllers (ยังเป็น lazyPut ได้)
    Get.lazyPut(() => ScrollpageController(), tag: 'home_scroll', fenix: true);
    Get.lazyPut(() => ScrollpageController(), tag: 'favorite_scroll', fenix: true);
    Get.lazyPut(() => ScrollpageController(), tag: 'myshop_scroll', fenix: true);
    // --- [TASK 12.2 - สิ้นสุดการแก้ไข] ---
  }
}