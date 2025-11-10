// lib/app/ui/pages/add_restaurant_page/add_restaurant_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

import '../../global_widgets/filter_ctrl.dart';
import '../login_page/login_controller.dart';
import '../../../routes/app_routes.dart';
// Import BannerType จาก Edit Controller (แหล่งกำเนิด)
import '../edit_restaurant_detail_page/edit_restaurant_detail_controller.dart' show BannerType;


class AddRestaurantController extends GetxController {
  // Controllers, State (Initialized as empty for new restaurant)
  final restaurantNameController = TextEditingController(); 
  final descriptionController = TextEditingController(); 
  final detailController = TextEditingController(); // สำหรับ detail
  final openingHoursController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final typeController = TextEditingController(); 
  final RxBool isLoading = false.obs;
  final RxString coverImageUrlOrPath = ''.obs; 
  final RxList<String> menuImageUrlsOrPaths = <String>[].obs;
  final RxList<String> bannerImageUrlsOrPaths = <String>[].obs;
  final Rx<BannerType> selectedBannerType = BannerType.image.obs;
  final RxList<TextEditingController> bannerTextControllers = <TextEditingController>[].obs;

  // Dependencies
  final LoginController _loginController = Get.find<LoginController>();
  final FilterController _filterController = Get.find<FilterController>();
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // <<<--- FIX 1: ลบการเพิ่ม Controller ใน onInit เพื่อให้ List เริ่มจากว่าง ---
    // bannerTextControllers.add(TextEditingController()); 
  }

  @override
  void onClose() {
    for (var controller in bannerTextControllers) { controller.dispose(); }
    restaurantNameController.dispose();
    descriptionController.dispose();
    detailController.dispose(); // Dispose detailController
    openingHoursController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    typeController.dispose();
    super.onClose();
  }

  // --- Image Picker Helpers (Omitted for brevity) ---
  Future<void> _pickImages(ImageSource source, {required String imageType}) async {
 	  final ImagePicker picker = ImagePicker();
 	  if (imageType == 'cover') { 
 		  final XFile? image = await picker.pickImage(source: source);
 		  if (image != null) { coverImageUrlOrPath.value = image.path; }
 	  } else { 
 		  final List<XFile> pickedFiles = await picker.pickMultiImage();
 		  if (pickedFiles.isNotEmpty) {
 			  final paths = pickedFiles.map((x) => x.path).toList();
 			  if (imageType == 'menu') { menuImageUrlsOrPaths.addAll(paths); } 
        else if (imageType == 'promotion') { bannerImageUrlsOrPaths.addAll(paths); }
 		  }
 	  }
  }
  void _showImagePickerBottomSheet({required String imageType}) {
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
 					  const ListTile(title: Text('เลือกรูปภาพ', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
 					  const Divider(thickness: 1),
 					  ListTile(leading: const Icon(Icons.camera_alt, color: Colors.pink), title: const Text('ถ่ายรูปจากกล้อง'), onTap: () { Get.back(); _pickImages(ImageSource.camera, imageType: imageType); }),
 					  ListTile(leading: const Icon(Icons.photo_library, color: Colors.blue), title: const Text('เลือกจากคลังรูปภาพ'), onTap: () { Get.back(); _pickImages(ImageSource.gallery, imageType: imageType); }),
 					  SafeArea(child: Container()),
 				  ]
 			  ),
 		  ),
 		  backgroundColor: Colors.transparent,
 		  elevation: 0,
 	  );
  }

  void pickCoverImage() => _showImagePickerBottomSheet(imageType: 'cover');
  void addMenuImages() => _showImagePickerBottomSheet(imageType: 'menu');
  void addPromotion() => _showImagePickerBottomSheet(imageType: 'promotion');
  void removeCoverImage() => coverImageUrlOrPath.value = '';
  void removeMenuImage(int index) { if (index >= 0 && index < menuImageUrlsOrPaths.length) { menuImageUrlsOrPaths.removeAt(index); } }
  void removeBannerImage(int index) { if (index >= 0 && index < bannerImageUrlsOrPaths.length) { bannerImageUrlsOrPaths.removeAt(index); } }
  
  // <<<--- 2. แก้ไข setBannerType: เพิ่ม Controller ตัวแรกเมื่อ List ว่าง ---
  void setBannerType(BannerType type) { 
    selectedBannerType.value = type;
    if (type == BannerType.image) {
      for (var controller in bannerTextControllers) { controller.dispose(); }
      bannerTextControllers.clear(); // Clear controllers for Image mode
    } else { // BannerType.text
      bannerImageUrlsOrPaths.clear();
      // FIX: ถ้า List ว่างอยู่ (เช่น มาจากโหมด Image) ให้เพิ่ม Controller ตัวแรกเพื่อให้ Text field แสดง
      if (bannerTextControllers.isEmpty) { 
          bannerTextControllers.add(TextEditingController()); 
      }
    }
  }
  
  void addBannerField() { bannerTextControllers.add(TextEditingController()); }
  void removeBannerField(int index) {
 	if (index >= 0 && index < bannerTextControllers.length) {
 	  bannerTextControllers[index].dispose();
 	  bannerTextControllers.removeAt(index);
 	}
  }

  // --- Upload Helper (Omitted for brevity) ---
  Future<String?> _uploadRestaurantImage(String imagePath, String restaurantIdStr, String imageTypeFolder) async {
 	  try {
 		  final file = File(imagePath);
 		  final fileExt = p.basename(imagePath).split('.').last;
 		  final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
 		  final filePath = '$restaurantIdStr/$imageTypeFolder/$fileName';

 		  await supabase.storage
 			  .from('restaurant_images')
 			  .upload(filePath, file, fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

 		  final imageUrl = supabase.storage
 			  .from('restaurant_images')
 			  .getPublicUrl(filePath);

 		  return '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
 	  } catch (e) {
 		  Get.snackbar('อัปโหลดผิดพลาด', 'ไม่สามารถอัปโหลดรูปภาพได้');
 		  return null;
 	  }
  }
  
  // --- [แก้ไข] Main Logic: Add New Restaurant (วิธีที่ 2: ส่งไปที่ restaurant_edits) ---
  Future<void> saveNewRestaurant() async { 
    // 1. Validation (Minimum)
    if (restaurantNameController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        latitudeController.text.trim().isEmpty ||
        longitudeController.text.trim().isEmpty) {
      Get.snackbar('ข้อผิดพลาด', 'กรุณากรอกชื่อร้าน คำอธิบาย และพิกัด');
      return;
    }
    if (_loginController.userId.value.isEmpty) {
        Get.snackbar('ข้อผิดพลาด', 'กรุณาเข้าสู่ระบบก่อนเพิ่มร้านค้า');
        return;
    }

    isLoading.value = true;
    final String ownerId = _loginController.userId.value;
    
    // Generate a temporary ID for the file upload path (Should use actual user ID)
    final String tempRestaurantId = supabase.auth.currentUser?.id ?? 'temp_new_shop'; 
    
    // 2. Process Images (Upload all new files)
    bool uploadErrorOccurred = false;
    String? finalCoverImageUrl;
    
    if (coverImageUrlOrPath.value.isNotEmpty && !coverImageUrlOrPath.value.startsWith('http')) {
        finalCoverImageUrl = await _uploadRestaurantImage(coverImageUrlOrPath.value, tempRestaurantId, 'cover');
        if (finalCoverImageUrl == null) { uploadErrorOccurred = true; }
    }

    List<String> finalMenuImageUrls = [];
    for (var path in menuImageUrlsOrPaths.where((p) => !p.startsWith('http')).toList()) {
        final uploadedUrl = await _uploadRestaurantImage(path, tempRestaurantId, 'menus');
        if (uploadedUrl != null) { finalMenuImageUrls.add(uploadedUrl); } else { uploadErrorOccurred = true; break; }
    }

    List<String> finalBannerUrls = [];
    if (selectedBannerType.value == BannerType.image) {
        for (var path in bannerImageUrlsOrPaths.where((p) => !p.startsWith('http')).toList()) {
            final uploadedUrl = await _uploadRestaurantImage(path, tempRestaurantId, 'promotions');
            if (uploadedUrl != null) { finalBannerUrls.add(uploadedUrl); } else { uploadErrorOccurred = true; break; }
        }
    } else {
        finalBannerUrls = bannerTextControllers.map((controller) => controller.text.trim()).where((text) => text.isNotEmpty).toList();
    }

    if (uploadErrorOccurred) {
        isLoading.value = false; // <<<--- [แก้ไข] หยุด Loading ที่นี่
        Get.snackbar('บันทึกผิดพลาด', 'เกิดปัญหาขณะอัปโหลดรูปภาพ โปรดลองอีกครั้ง');
        return;
    }
    
    // 3. Prepare Data for proposed_data (ข้อมูลร้านค้าทั้งหมด)
    final double? newLatitude = double.tryParse(latitudeController.text);
    final double? newLongitude = double.tryParse(longitudeController.text);
    
    final Map<String, dynamic> proposedRestaurantData = {
        'owner_id': ownerId, // Set the owner ID
        'res_name': restaurantNameController.text.trim(),
        'description': descriptionController.text.trim(),
        // 'description_inside': detailController.text.trim().isEmpty ? null : detailController.text.trim(), // <<<--- ใช้ 'detail'
        'detail': detailController.text.trim().isEmpty ? null : detailController.text.trim(), // <<<--- TASK 3
        'opening_hours': openingHoursController.text.trim().isEmpty ? null : openingHoursController.text.trim(),
        'phone_no': phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
        'food_type': typeController.text.trim().isEmpty ? null : typeController.text.trim(), 
        'res_img': finalCoverImageUrl,
        'promo_imgs_urls': finalBannerUrls,
        'latitude': newLatitude, // Required fields
        'longitude': newLongitude, // Required fields
        'location': locationController.text.trim().isEmpty ? null : locationController.text.trim(),
        'status': 'pending', // สถานะเริ่มต้นของร้าน
        'is_open': true, 
        'rating': 0.0, 
        'has_delivery': false, 
        // *** เพิ่มข้อมูลเมนูเข้าไปใน proposed_data ด้วย ***
        'menus': finalMenuImageUrls.map((url) => {
             // 'res_id': (Admin จะใส่ทีหลัง),
             'img_url': [url], // ห่อ URL ด้วย List[]
             'name': 'เมนู', 
             'price': 0 
         }).toList()
    };

    try {
        // 4. INSERT into restaurant_edits (แทน restaurants)
       await supabase
            .from('restaurant_edits')
            .insert({
              'user_id': ownerId, // ID ของคนที่ส่งคำขอ
              'res_id': null, // เป็น null เพราะเป็นร้านใหม่
              'edit_type': 'new_restaurant', // ประเภทการแก้ไขคือ 'เพิ่มร้านใหม่'
              'proposed_data': proposedRestaurantData, // ข้อมูลร้านทั้งหมดที่เตรียมไว้
              'status': 'pending', // สถานะคำขอ (รอ Admin อนุมัติ)
            });


        // 5. (ข้าม) ไม่ต้อง INSERT ลง 'menus' (Admin จะทำตอน approve)

        // 6. (ข้าม) ไม่ต้อง Refresh FilterController เพราะร้านยังไม่ 'approved'
        
        
        // --- [แก้ไข] ---
        // 1. กลับไปหน้าก่อนหน้า (สั่ง navigation)
        Get.back();
        // 2. แสดง Snackbar (จะไปแสดงที่หน้า MyShop)
        Get.snackbar('ส่งคำขอสำเร็จ', 'คำขอเพิ่มร้านค้าใหม่ถูกส่งให้ Admin ตรวจสอบแล้ว');
        // 3. หน่วงเวลาเล็กน้อย (เพื่อให้ Get.back() ทำงานเสร็จ)
        await Future.delayed(const Duration(milliseconds: 100));
        // 4. หยุด Loading (ตอนนี้จะ Rebuild ก็ไม่เป็นไร)
        isLoading.value = false; 
        // --- [สิ้นสุดการแก้ไข] ---

    } on PostgrestException catch (e) {
      print("Supabase Error: ${e.message}");
      print("Details: ${e.details}");
      print("Hint: ${e.hint}");
      print("Code: ${e.code}");
      Get.snackbar('ข้อผิดพลาด (DB)', 'ส่งคำขอไม่สำเร็จ: ${e.message}');
      isLoading.value = false; // <<<--- [แก้ไข] หยุด Loading ที่นี่
    } catch (e, st) {
      print("Unknown Error: $e");
      print("StackTrace: $st");
      Get.snackbar('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการส่งคำขอ: $e');
      isLoading.value = false; // <<<--- [แก้ไข] หยุด Loading ที่นี่
    } 
    // --- [ลบ] finally block ออก ---
    // finally {
    //   isLoading.value = false;
    // }
  }
}