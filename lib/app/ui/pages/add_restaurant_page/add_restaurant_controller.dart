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
import '../edit_restaurant_detail_page/edit_restaurant_detail_controller.dart' show BannerType, MenuItemController;


class AddRestaurantController extends GetxController {
  // Controllers, State (Initialized as empty for new restaurant)
  final restaurantNameController = TextEditingController(); 
  final descriptionController = TextEditingController(); 
  final detailController = TextEditingController(); 
  final openingHoursController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final typeController = TextEditingController(); 
  final RxBool isLoading = false.obs;
  final RxString coverImageUrlOrPath = ''.obs; 

  final RxList<MenuItemController> menuControllers = <MenuItemController>[].obs;
 
  final RxList<String> galleryImageUrlsOrPaths = <String>[].obs;
  final RxList<String> promotionImageUrlsOrPaths = <String>[].obs; 
  
  // <<<--- [TASK 16.11b - 1. เพิ่ม] State สำหรับ Checkboxes (ค่าเริ่มต้น false)
  final RxBool hasDelivery = false.obs;
  final RxBool hasDineIn = false.obs;
  // <<<--- [สิ้นสุดการเพิ่ม]
  
  final Rx<BannerType> selectedBannerType = BannerType.image.obs;
  final RxList<TextEditingController> bannerTextControllers = <TextEditingController>[].obs;

  // Dependencies
  final LoginController _loginController = Get.find<LoginController>();
  final FilterController _filterController = Get.find<FilterController>();
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // (ว่าง)
  }

  @override
  void onClose() {
    for (var controller in bannerTextControllers) { controller.dispose(); }
    for (var controller in menuControllers) {
      controller.dispose();
    }
    restaurantNameController.dispose();
    descriptionController.dispose();
    detailController.dispose(); 
    openingHoursController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    typeController.dispose();
    super.onClose();
  }

  // (Image Picker Helpers)
  Future<void> _pickImages(ImageSource source, {required String imageType}) async {
 	  final ImagePicker picker = ImagePicker();
 	  if (imageType == 'cover') { 
 		  final XFile? image = await picker.pickImage(source: source);
 		  if (image != null) { coverImageUrlOrPath.value = image.path; }
 	  } else { 
 		  final List<XFile> pickedFiles = await picker.pickMultiImage();
 		  if (pickedFiles.isNotEmpty) {
 			  final paths = pickedFiles.map((x) => x.path).toList();
 			  if (imageType == 'gallery') { 
 				  galleryImageUrlsOrPaths.addAll(paths);
 			  } else if (imageType == 'promotion') { 
          promotionImageUrlsOrPaths.addAll(paths); 
        }
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

  // (ฟังก์ชันปุ่มกดเลือกรูป)
  void pickCoverImage() => _showImagePickerBottomSheet(imageType: 'cover');
  void addGalleryImage() => _showImagePickerBottomSheet(imageType: 'gallery');
  void addPromotionImage() => _showImagePickerBottomSheet(imageType: 'promotion'); 
  void removeCoverImage() => coverImageUrlOrPath.value = '';
  void removeGalleryImage(int index) { 
    if (index >= 0 && index < galleryImageUrlsOrPaths.length) { 
      galleryImageUrlsOrPaths.removeAt(index); 
    } 
  }
  void removePromotionImage(int index) { 
    if (index >= 0 && index < promotionImageUrlsOrPaths.length) { 
      promotionImageUrlsOrPaths.removeAt(index); 
    } 
  }
  
  // (ฟังก์ชัน Menu Field)
  void addMenuItemField() {
    menuControllers.add(MenuItemController());
  }
  void removeMenuItemField(int index) {
    if (index >= 0 && index < menuControllers.length) {
      menuControllers[index].dispose();
      menuControllers.removeAt(index);
    }
  }

  // (ฟังก์ชันจัดการ Banner Type)
  void setBannerType(BannerType type) { 
    selectedBannerType.value = type;
    if (type == BannerType.image) {
      for (var controller in bannerTextControllers) { controller.dispose(); }
      bannerTextControllers.clear(); 
    } else { 
      promotionImageUrlsOrPaths.clear(); 
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

  // (ฟังก์ชันอัปโหลดรูป)
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
  
  // --- [TASK 16.11b - 2. แก้ไข] Main Logic: Add New Restaurant
  Future<void> saveNewRestaurant() async { 
    // (1. Validation)
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
    
    final String tempRestaurantId = supabase.auth.currentUser?.id ?? 'temp_new_shop'; 
    
    // (2. Process Images - Cover)
    bool uploadErrorOccurred = false;
    String? finalCoverImageUrl;
    
    if (coverImageUrlOrPath.value.isNotEmpty && !coverImageUrlOrPath.value.startsWith('http')) {
        finalCoverImageUrl = await _uploadRestaurantImage(coverImageUrlOrPath.value, tempRestaurantId, 'cover');
        if (finalCoverImageUrl == null) { uploadErrorOccurred = true; }
    }

    // (การประมวลผล Gallery Images)
    List<String> finalGalleryUrls = []; 
    for (var path in galleryImageUrlsOrPaths.where((p) => !p.startsWith('http')).toList()) { 
        final uploadedUrl = await _uploadRestaurantImage(path, tempRestaurantId, 'gallery'); 
        if (uploadedUrl != null) { finalGalleryUrls.add(uploadedUrl); } else { uploadErrorOccurred = true; break; }
    }

    // (การประมวลผล Promotion)
 	  List<String> finalPromotionUrlsOrText = []; 
 	  if (!uploadErrorOccurred && selectedBannerType.value == BannerType.image) {
 		  List<String> newPromotionPathsToUpload = []; 
 		  for (var urlOrPath in promotionImageUrlsOrPaths) { 
 			  if (urlOrPath.startsWith('http')) { finalPromotionUrlsOrText.add(urlOrPath); }
 			  else if (File(urlOrPath).existsSync()) { newPromotionPathsToUpload.add(urlOrPath); } 
 		  }
 		  for (var path in newPromotionPathsToUpload) { 
 			  final uploadedUrl = await _uploadRestaurantImage(path, tempRestaurantId, 'promotions'); 
 			  if (uploadedUrl != null) { finalPromotionUrlsOrText.add(uploadedUrl); }
 			  else { uploadErrorOccurred = true; break; }
 		  }
 	  } else if (selectedBannerType.value == BannerType.text) {
 		  finalPromotionUrlsOrText = bannerTextControllers.map((controller) => controller.text.trim()).where((text) => text.isNotEmpty).toList(); 
 	  }


    if (uploadErrorOccurred) {
        isLoading.value = false; 
        Get.snackbar('บันทึกผิดพลาด', 'เกิดปัญหาขณะอัปโหลดรูปภาพ โปรดลองอีกครั้ง');
        return;
    }
    
    // (ประมวลผล Menu Items (Text))
    List<Map<String, dynamic>> finalMenuItemsData = [];
    for (var menuCtrl in menuControllers) {
        final String name = menuCtrl.nameController.text.trim();
        final double price = double.tryParse(menuCtrl.priceController.text.trim()) ?? 0.0;
        if (name.isNotEmpty) {
            finalMenuItemsData.add({
              'name': name,
              'price': price,
            });
        }
    }

    // 3. Prepare Data for proposed_data
    final double? newLatitude = double.tryParse(latitudeController.text);
    final double? newLongitude = double.tryParse(longitudeController.text);
    
    // <<<--- [TASK 16.11b - 3. แก้ไข] proposedRestaurantData
    final Map<String, dynamic> proposedRestaurantData = {
        'owner_id': ownerId, 
        'res_name': restaurantNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'detail': detailController.text.trim().isEmpty ? null : detailController.text.trim(),
        'opening_hours': openingHoursController.text.trim().isEmpty ? null : openingHoursController.text.trim(),
        'phone_no': phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
        'food_type': typeController.text.trim().isEmpty ? null : typeController.text.trim(), 
        'res_img': finalCoverImageUrl,
        'gallery_imgs_urls': finalGalleryUrls, 
        'promo_imgs_urls': finalPromotionUrlsOrText, 
        'latitude': newLatitude, 
        'longitude': newLongitude, 
        'location': locationController.text.trim().isEmpty ? null : locationController.text.trim(),
        'status': 'pending', 
        'is_open': true, 
        'rating': 0.0, 
        'has_delivery': hasDelivery.value, // <<< [เพิ่ม]
        'has_dine_in': hasDineIn.value,   // <<< [เพิ่ม]
        'menus': finalMenuItemsData 
    };

    try {
        // 4. INSERT into restaurant_edits
       await supabase
            .from('restaurant_edits')
            .insert({
              'user_id': ownerId, 
              'res_id': null, 
              'edit_type': 'new_restaurant', 
              'proposed_data': proposedRestaurantData, 
              'status': 'pending', 
            });

        Get.back();
        Get.snackbar('ส่งคำขอสำเร็จ', 'คำขอเพิ่มร้านค้าใหม่ถูกส่งให้ Admin ตรวจสอบแล้ว');
        await Future.delayed(const Duration(milliseconds: 100));
        isLoading.value = false; 

    } on PostgrestException catch (e) {
      print("Supabase Error: ${e.message}");
      print("Details: ${e.details}");
      print("Hint: ${e.hint}");
      print("Code: ${e.code}");
      Get.snackbar('ข้อผิดพลาด (DB)', 'ส่งคำขอไม่สำเร็จ: ${e.message}');
      isLoading.value = false; 
    } catch (e, st) {
      print("Unknown Error: $e");
      print("StackTrace: $st");
      Get.snackbar('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการส่งคำขอ: $e');
      isLoading.value = false; 
    } 
  }
}