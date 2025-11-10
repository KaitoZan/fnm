// lib/app/ui/pages/login_page/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Text Editing Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State สำหรับ Password Visibility Icon (ใน TextField)
  var isPasswordVisible = false.obs; // <<<--- ใช้ State นี้ใน UI

  // State ของ User (ข้อมูลที่จำเป็นทั่วแอป)
  final RxBool isLoggedIn = false.obs; // สถานะ Login
  final RxString userId = ''.obs; // User ID (UUID String จาก Supabase Auth)
  final RxString userName = ''.obs; // ชื่อผู้ใช้ (จาก user_profiles.user_name)
  final RxString userEmail = ''.obs; // อีเมล (จาก Supabase Auth)
  final RxString userPhoneNumber = ''.obs; // เบอร์โทร (จาก user_profiles.phone_no)
  final RxString userlocations = ''.obs; // ที่อยู่ (จาก user_profiles.location)
  // final RxString userPassword = ''.obs; // ไม่ควรเก็บรหัสผ่านใน State
  final RxString userProfileImageUrl = ''.obs; // URL รูปโปรไฟล์ (จาก user_profiles.avatar_url)
  final RxList<String> userFavoriteList = <String>[].obs; // List<String> ของ ID ร้านโปรด (UUID String)

  // Supabase client instance
  final supabase = Supabase.instance.client;

  // Loading state (สำหรับปุ่ม Login และโหลด Profile)
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Listener สำหรับติดตามการเปลี่ยนแปลงสถานะ Authentication
    supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      
      // --- [แก้ไข] ---
      // ตรวจสอบ session และสถานะ isLoggedIn 
      // เพื่อป้องกันการเรียก _loadUserProfile ซ้ำซ้อน
      if (session != null && !isLoggedIn.value) {
        isLoading.value = true; 
        _loadUserProfile(session.user);
      } 
      else if (session == null && isLoggedIn.value) {
        _clearUserData(); // เคลียร์ข้อมูล User
        // (ลบ Get.offAllNamed ออกจากที่นี่ เพื่อแก้ปัญหา Ancestor)
      }
      // --- [สิ้นสุดการแก้ไข] ---
    });

    // --- [แก้ไข] ---
    // ลบการตรวจสอบ currentSession ที่ซ้ำซ้อนออก
    // ปล่อยให้ onAuthStateChange (ด้านบน) จัดการการโหลดครั้งแรกเอง
    final currentSession = supabase.auth.currentSession;
    if (currentSession == null) {
      isLoggedIn.value = false; 
      isLoading.value = false; 
    }
    // --- [สิ้นสุดการแก้ไข] ---
  }

  // ฟังก์ชันสำหรับการ Login
  void fetchLogin() async {
    final String inputEmail = emailController.text.trim();
    final String inputPassword = passwordController.text.trim(); // Trim password ด้วย

    // (...ส่วน Validation คงเดิม...)
    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      Get.closeCurrentSnackbar(); 
      Get.snackbar(
        'System',
        'กรุณากรอกอีเมลและรหัสผ่าน',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withValues(alpha: 0.1),
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    } else if (!GetUtils.isEmail(inputEmail)) { 
      Get.closeCurrentSnackbar(); 
      Get.snackbar(
        'System',
        'กรุณากรอกอีเมลให้ถูกต้อง',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withValues(alpha: 0.1),
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    }

    isLoading.value = true; 

    try {
      // เรียกใช้ Supabase Auth signInWithPassword
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: inputEmail,
        password: inputPassword,
      );

      if (res.user != null) {
        // Login สำเร็จ
        // (onAuthStateChange listener จะเรียก _loadUserProfile ให้อัตโนมัติ)
        emailController.clear();
        passwordController.clear();
        FocusScope.of(Get.context!).unfocus();
      }

    } on AuthException catch (e) {
      // ( ... Error Handling คงเดิม ... )
      isLoading.value = false; 
      Get.closeCurrentSnackbar(); 
      Get.snackbar(
        'System',
        'รหัสผ่านหรืออีเมลของคุณไม่ถูกต้อง',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      // ( ... Error Handling คงเดิม ... )
      isLoading.value = false; 
      Get.closeCurrentSnackbar(); 
      Get.snackbar(
        'System',
        'เกิดข้อผิดพลาดในการเข้าสู่ระบบ: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // ฟังก์ชันโหลดข้อมูล User Profile
  Future<void> _loadUserProfile(User user) async {
    try {
      // ( ... ดึง profileData และ favoriteData คงเดิม ... )
      final profileData = await supabase
          .from('user_profiles') 
          .select()
          .eq('id', user.id)
          .single();

      final favoriteData = await supabase
          .from('favorite_restaurants')
          .select('res_id') 
          .eq('user_id', user.id);

      // อัปเดต State
      isLoggedIn.value = true;
      userId.value = user.id;
      userEmail.value = user.email ?? '';

      userName.value = profileData['user_name'] ?? 'ผู้ใช้'; 
      userPhoneNumber.value = profileData['phone_no'] ?? ''; 
      userProfileImageUrl.value = profileData['avatar_url'] ?? 'assets/ics/person.png';
      userlocations.value = profileData['location'] ?? ''; 

      userFavoriteList.value = favoriteData
          .map((row) => row['res_id'] as String) 
          .toList();

       print("User profile loaded: ${userName.value}");
       print("Favorites loaded: ${userFavoriteList.length}");

       isLoading.value = false; // <<<--- หยุด Loading

       Get.closeCurrentSnackbar(); 
      

       // Navigate ไป Navbar
       if (Get.currentRoute != AppRoutes.NAVBAR) {
          Get.offAllNamed(AppRoutes.NAVBAR);
       }

    } catch (e) {
      // ( ... Error Handling คงเดิม ... )
      isLoading.value = false; 
      Get.closeCurrentSnackbar(); 
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถโหลดข้อมูลโปรไฟล์ได้ โปรดลองเข้าสู่ระบบใหม่',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      await logout(); 
    }
  }
  
  // ฟังก์ชัน Logout
  Future<void> logout() async {
    isLoading.value = true; 
    try {
        await supabase.auth.signOut(); 
        // (onAuthStateChange listener จะเรียก _clearUserData())
    } catch (e) {
        isLoading.value = false; 
        Get.closeCurrentSnackbar(); 
        print("Error signing out: $e");
         Get.snackbar(
            'ข้อผิดพลาด',
            'เกิดข้อผิดพลาดในการออกจากระบบ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
         );
         _clearUserData(); // เคลียร์เอง
    }
  }

  // ฟังก์ชันเคลียร์ข้อมูล User ใน State
  void _clearUserData() {
    isLoggedIn.value = false;
    userId.value = '';
    userName.value = '';
    userEmail.value = '';
    userProfileImageUrl.value = 'assets/ics/person.png';
    userPhoneNumber.value = '';
    userlocations.value = '';
    userFavoriteList.clear();
    isLoading.value = false; 
    print("User data cleared.");
  }

  // ฟังก์ชันสลับ visibility ของ password icon
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

} // End of Controller