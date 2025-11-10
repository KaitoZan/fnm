import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:get/get.dart';
// import '../../utils/logget.dart'; // --- ไม่ใช้ Log ชั่วคราว ---
import 'dart:developer' as developer; // --- ใช้ developer.log แทน print ---

class SplashController extends GetxController {
   @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(AppRoutes.NAVBAR);
    });
  }
}