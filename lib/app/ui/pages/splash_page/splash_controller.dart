import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:get/get.dart';
// import '../../utils/logget.dart'; // --- ไม่ใช้ Log ชั่วคราว ---
import 'dart:developer' as developer; // --- ใช้ developer.log แทน print ---

// <<<--- [TASK 12.2 - เพิ่ม] Import FilterController
import '../../global_widgets/filter_ctrl.dart';

class SplashController extends GetxController {
  
  // <<<--- [TASK 12.2 - เพิ่ม] Find FilterController
  final FilterController _filterController = Get.find<FilterController>();

   @override
  void onReady() {
    super.onReady();
    // <<<--- [TASK 12.2 - แก้ไข] ---
    // (ลบ Logic การรอ 5 วินาที)
    // Future.delayed(const Duration(seconds: 5), () {
    //   Get.offAllNamed(AppRoutes.NAVBAR);
    // });
    
    // (เพิ่ม Logic ใหม่: โหลดข้อมูลแล้วค่อยไป)
    _loadDataAndNavigate();
    // <<<--- [TASK 12.2 - สิ้นสุดการแก้ไข] ---
  }

  // <<<--- [TASK 12.2 - เพิ่ม] ฟังก์ชันใหม่ ---
  Future<void> _loadDataAndNavigate() async {
    try {
      // 1. สั่งให้ FilterController โหลดข้อมูลร้านอาหาร และรอจนกว่าจะเสร็จ
      await _filterController.initializeAllRestaurants();
      
      // (ถ้ามีข้อมูลอื่นๆ ที่ต้องโหลดก่อนเข้าแอป ให้ await ที่นี่ต่อ)
      
    } catch (e) {
      // (จัดการ Error หากการโหลดครั้งแรกล้มเหลว)
      developer.log("Error loading initial data: $e", name: "SplashController");
      // (แม้จะ Error แต่ก็ต้องไปต่อ)
    }
    
    // 2. เมื่อโหลดเสร็จ (หรือ Error) ให้นำทางไปหน้า Navbar
    Get.offAllNamed(AppRoutes.NAVBAR);
  }
  // <<<--- [TASK 12.2 - สิ้นสุดการเพิ่ม] ---
}