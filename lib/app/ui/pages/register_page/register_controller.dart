// lib/app/ui/pages/register_page/register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../../../routes/app_routes.dart';
// import '../login_page/login_controller.dart'; // ไม่ได้ใช้ LoginController โดยตรงแล้ว

class RegisterController extends GetxController {
  // Text Editing Controllers
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // State สำหรับ Password Visibility
  final _obscureText = true.obs;
  final _obscureText2 = true.obs;
  get obscureText => _obscureText.value;
  get obscureText2 => _obscureText2.value;
  set obscureText(value) => _obscureText.value = value;
  set obscureText2(value) => _obscureText2.value = value;

  // State สำหรับเก็บ Path รูปโปรไฟล์ที่เลือก
  final RxString _selectedProfileImagePath = ''.obs;
  String get selectedProfileImagePath => _selectedProfileImagePath.value;

  // Supabase client instance
  final supabase = Supabase.instance.client;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  // แสดง BottomSheet ให้เลือกแหล่งที่มาของรูปภาพ
  Future<void> pickProfileImage() async {
      Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Wrap( // ใช้ Wrap เพื่อให้ content พอดีกับความสูง
          children: <Widget>[
              const SizedBox( // เพิ่ม Header Text
                height: 50,
                child: Center(
                  child: Text(
                    'เลือกรูปโปรไฟล์',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('ถ่ายรูปจากกล้อง'),
              onTap: () {
                Get.back(); // ปิด BottomSheet
                _pickImage(ImageSource.camera); // เลือกจากกล้อง
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('เลือกจากคลังรูปภาพ'),
              onTap: () {
                Get.back(); // ปิด BottomSheet
                _pickImage(ImageSource.gallery); // เลือกจากคลังภาพ
              },
            ),
            SafeArea(child: Container()), // เพิ่มระยะห่างด้านล่างสำหรับบางอุปกรณ์
          ],
        ),
      ),
      backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
      elevation: 0, // ไม่มีเงา
    );
  }

  // เลือกรูปจากแหล่งที่มากำหนด และอัปเดต State _selectedProfileImagePath
  Future<void> _pickImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
          // อัปเดต State ด้วย Path ของรูปที่เลือก
          _selectedProfileImagePath.value = image.path;
      }
  }

  // ฟังก์ชันสำหรับการลงทะเบียน
  void fetchRegister() async {
    FocusScope.of(Get.context!).unfocus(); // ซ่อน Keyboard
    // ตรวจสอบข้อมูลเบื้องต้น
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty || // รหัสผ่านไม่ต้อง trim
        usernameController.text.trim().isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneNumberController.text.trim().isEmpty) {
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'System',
        'กรุณากรอกข้อมูลให้ครบถ้วน',
        snackPosition: SnackPosition.TOP,
        // --- คง withValues ไว้ ---
        backgroundColor: Colors.black.withValues(alpha: 0.1),
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) { // ใช้ GetUtils.isEmail
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
    if (passwordController.text.length < 6) {
       Get.closeCurrentSnackbar();
       Get.snackbar(
        'System',
        'กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัวอักษร',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withValues(alpha: 0.1),
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
       Get.closeCurrentSnackbar();
       Get.snackbar(
        'System',
        'รหัสผ่านไม่ตรงกัน',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withValues(alpha: 0.1),
        colorText: Colors.black,
        duration: const Duration(milliseconds: 900),
      );
      return;
    }

    isLoading.value = true; // เริ่ม Loading

    try {
      String? avatarUrl; // URL รูปโปรไฟล์หลังอัปโหลด (อาจเป็น null)
      // ถ้ามีการเลือกรูปโปรไฟล์
      if (_selectedProfileImagePath.value.isNotEmpty) {
        // อัปโหลดรูป (ส่ง userId เป็น null เพราะยังไม่มี ID ตอนสมัคร)
        avatarUrl = await _uploadProfileImage(_selectedProfileImagePath.value, null);
        if (avatarUrl == null) {
          // ถ้าอัปโหลดไม่สำเร็จ ให้หยุดและแจ้งเตือน (แต่ยังไม่หยุด Loading)
          Get.closeCurrentSnackbar(); // <<<--- FIX: ปิด Snackbar เก่า
          Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถอัปโหลดรูปโปรไฟล์ได้');
          isLoading.value = false; // หยุด Loading ถ้าอัปโหลดรูปไม่สำเร็จ
          return;
        }
      }

      // เรียก Supabase Auth signUp
      final AuthResponse res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(), // ส่ง password ที่ trim แล้ว
        // ส่งข้อมูลเพิ่มเติม (user_name, phone_no, avatar_url)
        // Trigger ใน Supabase จะนำข้อมูลนี้ไปสร้างแถวในตาราง user_profiles
        data: {
          'user_name': usernameController.text.trim(), // ชื่อคอลัมน์ user_name
          'phone_no': phoneNumberController.text.trim(), // ชื่อคอลัมน์ phone_no
          'avatar_url': avatarUrl, // ส่ง URL ที่ได้จากการอัปโหลด (อาจเป็น null)
        },
      );

      // จัดการผลลัพธ์หลัง signUp
      if (res.user != null) {
        // ลงทะเบียนสำเร็จ
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        phoneNumberController.clear();
        _selectedProfileImagePath.value = '';

        isLoading.value = false; // หยุด Loading

        Get.closeCurrentSnackbar(); // <<<--- FIX: ปิด Snackbar เก่า
        Get.snackbar(
          'System',
          'ลงทะเบียนสำเร็จ! กรุณาตรวจสอบอีเมลเพื่อยืนยัน (ถ้ามี)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8), // สีเขียวแจ้งสำเร็จ
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.LOGIN); // กลับไปหน้า Login
      }
      // กรณี Email ซ้ำ Supabase จะ throw AuthException

    } on AuthException catch (e) {
      // จัดการข้อผิดพลาดจาก Supabase Auth
      isLoading.value = false; // หยุด Loading
      Get.closeCurrentSnackbar(); // <<<--- FIX: ปิด Snackbar เก่า
      Get.snackbar(
        'System',
        'ลงทะเบียนไม่สำเร็จ: ${e.message}', // แสดงข้อความจาก Supabase
         snackPosition: SnackPosition.TOP,
         backgroundColor: Colors.red.withOpacity(0.8), // สีแดงแจ้ง Error
         colorText: Colors.white,
      );
    } catch (e) {
      // จัดการข้อผิดพลาดอื่นๆ
      isLoading.value = false; // หยุด Loading
      Get.closeCurrentSnackbar(); // <<<--- FIX: ปิด Snackbar เก่า
      Get.snackbar(
        'System',
        'เกิดข้อผิดพลาด: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // ฟังก์ชันอัปโหลดรูปโปรไฟล์
  Future<String?> _uploadProfileImage(String imagePath, String? userId) async {
    try {
      final file = File(imagePath);
      final fileExt = imagePath.split('.').last;
      final String fileNameBase = userId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = '$fileNameBase.$fileExt';
      // Path ใน Storage: ถ้ามี userId เก็บใน folder userId, ถ้าไม่มี เก็บใน public
      final String filePath = userId != null ? '$userId/$fileName' : 'public/$fileName';

      // อัปโหลดไปยัง Bucket 'avatars' (upsert: true คือเขียนทับถ้ามีไฟล์ชื่อเดิม)
      await supabase.storage.from('avatars').upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // ดึง Public URL
      final imageUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      print('Uploaded image URL: $imageUrl');
      // เพิ่ม timestamp query parameter เพื่อแก้ปัญหา cache
      return '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Error uploading profile image: $e');
      return null; // คืนค่า null ถ้าอัปโหลดไม่สำเร็จ
    }
  }
} // End of Controller