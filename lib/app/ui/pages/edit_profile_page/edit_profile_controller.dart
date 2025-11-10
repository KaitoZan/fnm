// lib/app/ui/pages/edit_profile_page/edit_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../login_page/login_controller.dart';

class EditProfileController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();

  // Controllers สำหรับ TextFields
  final nicknameController = TextEditingController(); // สำหรับ user_name
  final phoneController = TextEditingController(); // สำหรับ phone_no
  final emailController = TextEditingController(); // Email (แสดงผลอย่างเดียว ไม่ควรให้แก้)
  final locationController = TextEditingController(); // ที่อยู่ (ถ้ามี field นี้ใน user_profiles)

  final RxBool isLoading = false.obs; // State สำหรับ Loading ตอนบันทึก

  // State สำหรับเก็บ URL/Path รูปโปรไฟล์ที่กำลังจะแสดง/แก้ไข
  final RxString imgProfileImageUrl = ''.obs; // ใช้ชื่อนี้ตาม UI Widget เดิม

  // Supabase client instance
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // โหลดข้อมูล User ปัจจุบันจาก LoginController มาใส่ใน TextFields
    nicknameController.text = _loginController.userName.value; // userName (user_name)
    phoneController.text = _loginController.userPhoneNumber.value; // userPhoneNumber (phone_no)
    emailController.text = _loginController.userEmail.value; // แสดง Email ปัจจุบัน (ไม่ควรให้แก้)
    imgProfileImageUrl.value = _loginController.userProfileImageUrl.value; // โหลด URL รูปปัจจุบัน (avatar_url)
    locationController.text = _loginController.userlocations.value; // โหลดที่อยู่ (ถ้าใช้)
  }

  @override
  void onClose() {
    // Dispose Controllers เมื่อ Controller นี้ถูกทำลาย
    nicknameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
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
        child: Wrap(
          children: <Widget>[
            const ListTile(
              title: Text(
                'เลือกรูปโปรไฟล์',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('ถ่ายรูปจากกล้อง'),
              onTap: () {
                _pickImageAndUpdateImgUrl(ImageSource.camera); // เรียกใช้ฟังก์ชันเลือกรูป
                Get.back(); // ปิด BottomSheet
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('เลือกจากคลังรูปภาพ'),
              onTap: () {
                _pickImageAndUpdateImgUrl(ImageSource.gallery); // เรียกใช้ฟังก์ชันเลือกรูป
                Get.back(); // ปิด BottomSheet
              },
            ),
            SafeArea(child: Container()), // เพิ่มระยะห่างด้านล่าง
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  // เลือกรูปจากแหล่งที่มาที่กำหนด และอัปเดต State imgProfileImageUrl (ชั่วคราวด้วย Path)
  Future<void> _pickImageAndUpdateImgUrl(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // อัปเดต State ด้วย Path ของรูปที่เลือก เพื่อให้ UI แสดงรูปใหม่ทันที
      imgProfileImageUrl.value = image.path;
    }
  }


  // บันทึกข้อมูล Profile ที่แก้ไข
  // บันทึกข้อมูล Profile ที่แก้ไข
  void saveProfile() async {
    FocusScope.of(Get.context!).unfocus(); // ซ่อน Keyboard

    // ตรวจสอบข้อมูลเบื้องต้น
    // อนุญาตให้เบอร์โทรว่างได้ แต่ถ้าไม่ว่างต้อง 10 หลัก
    if (phoneController.text.trim().isNotEmpty && phoneController.text.trim().length != 10) {
      Get.snackbar(
        "ข้อผิดพลาด",
        "หมายเลขโทรศัพท์ไม่ถูกต้อง (ต้องมี 10 หลัก หรือเว้นว่าง)",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    if (nicknameController.text.trim().isEmpty) { // ตรวจสอบชื่อผู้ใช้ (user_name)
      Get.snackbar(
        "ข้อผิดพลาด",
        "กรุณากรอกชื่อผู้ใช้",
       snackPosition: SnackPosition.TOP,
       backgroundColor: Colors.red.withOpacity(0.8),
       colorText: Colors.white,
      );
      return;
    }

    // ตรวจสอบสถานะ Login
    if (!_loginController.isLoggedIn.value || _loginController.userId.value.isEmpty) {
         Get.snackbar(
            "ข้อผิดพลาด",
            "ไม่สามารถบันทึกข้อมูลได้: ไม่ได้เข้าสู่ระบบ",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
         );
      return;
    }

    isLoading.value = true; // เริ่ม Loading
    // ใช้ URL เดิมจาก LoginController เป็นค่าเริ่มต้น
    String? finalImageUrl = _loginController.userProfileImageUrl.value;
    // ตรวจสอบว่า URL เดิมเป็น asset หรือไม่ ถ้าใช่ให้ถือว่าเป็น null ก่อนอัปโหลด
    if (finalImageUrl.startsWith('assets/')) {
        finalImageUrl = null;
    }

    try {
      // --- ตรวจสอบว่ามีการเปลี่ยนรูปหรือไม่ ---
      // ถ้า imgProfileImageUrl ไม่ใช่ค่าว่าง และไม่ได้ขึ้นต้นด้วย http แสดงว่าเป็น Path รูปใหม่
      if (imgProfileImageUrl.value.isNotEmpty &&
          !imgProfileImageUrl.value.startsWith('http')) {
        // --- ถ้ามีการเปลี่ยนรูป -> อัปโหลดรูปใหม่ ---
        final uploadedUrl = await _uploadProfileImage(
            imgProfileImageUrl.value, _loginController.userId.value);
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl; // ใช้ URL ใหม่ที่อัปโหลดสำเร็จ
        } else {
          // ถ้าอัปโหลดไม่สำเร็จ แจ้งเตือนและหยุด
          Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถอัปโหลดรูปโปรไฟล์ใหม่ได้');
          isLoading.value = false;
          return;
        }
      } else if (imgProfileImageUrl.value.isEmpty && (_loginController.userProfileImageUrl.value.isNotEmpty && !_loginController.userProfileImageUrl.value.startsWith('assets/')) ) {
           // กรณีผู้ใช้ลบรูป (สมมติว่ากดปุ่ม x) และมี URL เดิมอยู่ (ไม่ใช่ asset)
           finalImageUrl = 'assets/ics/person.png'; // กลับไปใช้รูป Default (หรือ null ถ้าต้องการ)
      }


      // --- อัปเดตข้อมูล Text และ URL รูป (avatar_url) ไปที่ตาราง user_profiles ---
      await supabase.from('user_profiles').update({ // ชื่อตาราง user_profiles
        'user_name': nicknameController.text.trim(), // ชื่อคอลัมน์ user_name
        'phone_no': phoneController.text.trim().isEmpty ? null : phoneController.text.trim(), // ชื่อคอลัมน์ phone_no (ถ้าว่างให้เป็น null)
        'avatar_url': finalImageUrl, // ชื่อคอลัมน์ avatar_url (ใช้ URL ล่าสุด อาจเป็น null หรือ asset path)
        
        // --- [แก้ไข] เปิดการใช้งานบรรทัดนี้ ---
        'location': locationController.text.trim().isEmpty ? null : locationController.text.trim(), // <<<--- แก้ไขที่นี่
        // --- [สิ้นสุดการแก้ไข] ---

      }).eq('id', _loginController.userId.value); // ระบุ user ที่ต้องการอัปเดต

      // --- อัปเดต State ใน LoginController ด้วยข้อมูลล่าสุด ---
      _loginController.userName.value = nicknameController.text.trim(); // user_name
      _loginController.userPhoneNumber.value = phoneController.text.trim(); // phone_no
      // อัปเดต URL ล่าสุด (ถ้าเป็น null ให้ใช้รูป default)
      _loginController.userProfileImageUrl.value = finalImageUrl ?? 'assets/ics/person.png'; // avatar_url
      
      // --- [แก้ไข] อัปเดต userlocations ด้วย ---
      _loginController.userlocations.value = locationController.text.trim(); // <<<--- แก้ไขที่นี่
      // --- [สิ้นสุดการแก้ไข] ---

      Get.back(); // กลับไปหน้า Profile
      Get.snackbar(
        "สำเร็จ",
        "บันทึกข้อมูลเรียบร้อยแล้ว",
         snackPosition: SnackPosition.TOP,
         backgroundColor: Colors.green.withOpacity(0.8), // สีเขียวแจ้งสำเร็จ
         colorText: Colors.white,
      );

    } catch (e) {
      // จัดการ Error กรณีบันทึกไม่สำเร็จ
      Get.snackbar(
        "ข้อผิดพลาด",
        "ไม่สามารถบันทึกข้อมูลได้: ${e.toString()}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8), // สีแดงแจ้ง Error
          colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // สิ้นสุด Loading
    }
  }

  // ฟังก์ชันอัปโหลดรูปโปรไฟล์
  Future<String?> _uploadProfileImage(String imagePath, String userId) async {
    try {
      final file = File(imagePath);
      final fileExt = imagePath.split('.').last;
      // ใช้ userId เป็นชื่อไฟล์หลัก เพื่อให้เขียนทับได้ง่าย
      final fileName = '$userId.$fileExt';
      // เก็บใน Folder ชื่อตาม userId ใน Bucket 'avatars'
      final filePath = '$userId/$fileName';

      // อัปโหลดไฟล์ (upsert: true คือเขียนทับถ้ามีไฟล์ชื่อเดิม)
      await supabase.storage.from('avatars').upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // ดึง Public URL ของไฟล์ที่อัปโหลด
      final imageUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      // เพิ่ม timestamp query parameter เพื่อแก้ปัญหา Cache รูปเก่า
      return '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      print('Error uploading profile image: $e');
      return null; // คืนค่า null ถ้าอัปโหลดไม่สำเร็จ
    }
  }

  // --- (Optional) ฟังก์ชันสำหรับลบรูปโปรไฟล์ออกจาก Storage ---
  // Future<void> _deleteProfileImage(String userId) async {
  //    try {
  //       // ต้อง List ไฟล์ใน folder ของ userId ก่อน แล้วค่อยลบ
  //       final List<FileObject> files = await supabase.storage.from('avatars').list(path: userId);
  //       if (files.isNotEmpty) {
  //          final List<String> pathsToDelete = files.map((file) => '$userId/${file.name}').toList();
  //          await supabase.storage.from('avatars').remove(pathsToDelete);
  //          print("Deleted profile image for user: $userId");
  //       }
  //    } catch (e) {
  //       print("Error deleting profile image: $e");
  //       // อาจจะแจ้งเตือนหรือไม่ก็ได้
  //    }
  // }

} // End of Controller