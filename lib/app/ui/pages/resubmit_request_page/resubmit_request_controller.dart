// lib/app/ui/pages/my_shop_page/widgets/resubmit_request_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

// 1. Import Model เพื่อใช้ Enum และ parseStatus

// (Import BannerType จาก Edit Controller)
import '../../../model/my_request_status.dart';

import '../edit_restaurant_detail_page/edit_restaurant_detail_controller.dart';
import '../my_shop_page/my_shop_controller.dart'; // Import MyShopController

/*
 * Controller นี้ใช้สำหรับ "ดู" หรือ "แก้ไขและส่งใหม่" (Resubmit)
 * ข้อมูลจากตาราง 'restaurant_edits'
 */
class ResubmitRequestController extends GetxController {
  final int requestEditId; // ID (bigint) จากตาราง restaurant_edits
  final supabase = Supabase.instance.client;

  // Controllers, State
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
  final RxList<String> menuImageUrlsOrPaths = <String>[].obs;
  final RxList<String> bannerImageUrlsOrPaths = <String>[].obs;

  // State สำหรับโปรโมชั่น
  final Rx<BannerType> selectedBannerType = BannerType.image.obs;
  final RxList<TextEditingController> bannerTextControllers = <TextEditingController>[].obs;
  
  // State สำหรับเก็บข้อมูลที่ดึงมา
  final RxBool isPageLoading = true.obs;
  final RxString rejectionReason = ''.obs; 

  // <<< 2. เพิ่ม State สำหรับเก็บสถานะ ---
  final Rx<RequestStatus> originalStatus = RequestStatus.pending.obs;

  // Original Data (สำหรับเทียบตอน Upload รูป)
  String? _originalCoverImageUrl;
  List<String> _originalMenuImageUrls = [];
  List<String> _originalBannerImageUrls = [];
  String _originalLocationText = '';
  double? _originalLatitude;
  double? _originalLongitude;

  ResubmitRequestController({required this.requestEditId});

  @override
  void onInit() {
    super.onInit();
    if (requestEditId == 0) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่พบ ID ของคำร้อง');
      Get.back();
    } else {
      _loadDataFromRequest();
    }
  }

  // 1. โหลดข้อมูลจากตาราง restaurant_edits
  Future<void> _loadDataFromRequest() async {
    isPageLoading.value = true;
    try {
      final data = await supabase
          .from('restaurant_edits')
          .select()
          .eq('id', requestEditId)
          .single();

      // ดึงข้อมูลจาก proposed_data (JSONB)
      final proposedData = data['proposed_data'] as Map<String, dynamic>? ?? {};
      rejectionReason.value = data['rejection_reason'] ?? '';
      
      // <<< 3. เก็บสถานะที่โหลดมา ---
      originalStatus.value = MyRequestStatus.parseStatus(data['status'] ?? 'pending');

      // 1. โหลด Text Fields
      restaurantNameController.text = proposedData['res_name'] ?? '';
      descriptionController.text = proposedData['description'] ?? '';
      detailController.text = proposedData['detail'] ?? ''; 
      openingHoursController.text = proposedData['opening_hours'] ?? '';
      phoneNumberController.text = proposedData['phone_no'] ?? '';
      locationController.text = proposedData['location'] ?? '';
      latitudeController.text = proposedData['latitude']?.toString() ?? '';
      longitudeController.text = proposedData['longitude']?.toString() ?? '';
      typeController.text = proposedData['food_type'] ?? '';

      // (เก็บค่า Location เดิม)
 	  _originalLatitude = (proposedData['latitude'] as num?)?.toDouble();
 	  _originalLongitude = (proposedData['longitude'] as num?)?.toDouble();
 	  _originalLocationText = proposedData['location'] ?? '';

      // 2. โหลดรูปภาพ
      final String coverImg = proposedData['res_img'] ?? '';
      coverImageUrlOrPath.value = coverImg;
      _originalCoverImageUrl = coverImg;

      // (เมนู: proposed_data['menus'] เป็น List<Map<String, dynamic>>)
      final List<dynamic> menuData = proposedData['menus'] as List<dynamic>? ?? [];
      final List<String> menuImages = [];
      for (var menu in menuData) {
         final dynamic imgUrlData = menu['img_url'];
         if (imgUrlData is List && imgUrlData.isNotEmpty) {
            final String? firstUrl = imgUrlData.first as String?;
            if (firstUrl != null && firstUrl.isNotEmpty) {
                menuImages.add(firstUrl);
            }
         }
      }
      menuImageUrlsOrPaths.assignAll(menuImages);
      _originalMenuImageUrls = List.from(menuImages);


      // 3. โหลดโปรโมชั่น (proposed_data['promo_imgs_urls'] เป็น List<String>)
      final List<String> promotion = List<String>.from(proposedData['promo_imgs_urls'] ?? []);
      bool isImageBanner = promotion.isNotEmpty && (promotion.any((url) => url.startsWith('http')));

      if (isImageBanner) {
        selectedBannerType.value = BannerType.image;
        bannerImageUrlsOrPaths.assignAll(_originalBannerImageUrls = List.from(promotion));
        for (var controller in bannerTextControllers) { controller.dispose(); }
        bannerTextControllers.clear();
      } else { 
        selectedBannerType.value = BannerType.text;
        bannerImageUrlsOrPaths.clear();
        _originalBannerImageUrls = [];
        for (var controller in bannerTextControllers) { controller.dispose(); }
        bannerTextControllers.assignAll(promotion
            .map((text) => TextEditingController(text: text))
            .toList());
      }
      
      isPageLoading.value = false;

    } catch (e) {
      isPageLoading.value = false;
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถโหลดข้อมูลคำร้องได้: $e');
      Get.back();
    }
  }

  // --- (ฟังก์ชันจัดการรูปภาพ: _pickImages, _showImagePickerBottomSheet, pick/add/remove) ---
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
  
  // --- (ฟังก์ชันจัดการ Banner Type: setBannerType, add/removeBannerField) ---
  void setBannerType(BannerType type) { 
    selectedBannerType.value = type;
    if (type == BannerType.image) {
      for (var controller in bannerTextControllers) { controller.dispose(); }
      bannerTextControllers.clear(); 
    } else { 
      bannerImageUrlsOrPaths.clear();
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

  // --- (ฟังก์ชันอัปโหลด/ลบรูป: _uploadRestaurantImage, _deleteRestaurantImages) ---
  Future<String?> _uploadRestaurantImage(String imagePath, String restaurantIdStr, String imageTypeFolder) async {
 	  try {
 		  final file = File(imagePath);
 		  final fileExt = p.basename(imagePath).split('.').last;
 		  final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
       final String userId = supabase.auth.currentUser?.id ?? 'unknown_user';
 		  final filePath = '$userId/$imageTypeFolder/$fileName'; 

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
  Future<void> _deleteRestaurantImages(List<String> urlsToDelete) async {
 	  if (urlsToDelete.isEmpty) return;
 	  List<String> pathsToDelete = [];
 	  for (var url in urlsToDelete) {
 		  if (url.isNotEmpty && url.contains('/storage/v1/object/public/restaurant_images/')) {
 			  try {
 				  final uri = Uri.parse(url);
 				  final pathSegments = uri.pathSegments;
 				  int bucketNameIndex = pathSegments.indexOf('restaurant_images');
 				  if (bucketNameIndex != -1 && pathSegments.length > bucketNameIndex + 1) {
 					  pathsToDelete.add(pathSegments.sublist(bucketNameIndex + 1).join('/'));
 				  } 
 			  } catch (e) { print("Error parsing URL to delete: $url, Error: $e"); }
 		  } 
 	  }
 	  if (pathsToDelete.isNotEmpty) {
 		  try {
 			  await supabase.storage.from('restaurant_images').remove(pathsToDelete);
 		  } catch (e) {
 			  print("Error deleting images from storage: $e");
 	  }
 	  }
  }


  // 2. ฟังก์ชัน "ส่งคำร้องใหม่" (Resubmit)
  Future<void> resubmitRequest() async {
    isLoading.value = true;
    FocusScope.of(Get.context!).unfocus();
    
    final String currentUserId = supabase.auth.currentUser?.id ?? 'temp_resubmit';
    
    // (ประมวลผลรูปภาพ)
    List<String> urlsToDeleteFromStorage = [];
    bool uploadErrorOccurred = false;
    
    // 1. Cover Image
    String? finalCoverImageUrl = _originalCoverImageUrl;
    if (coverImageUrlOrPath.value.isNotEmpty && !coverImageUrlOrPath.value.startsWith('http')) {
      final uploadedUrl = await _uploadRestaurantImage(coverImageUrlOrPath.value, currentUserId, 'cover');
      if (uploadedUrl != null) {
        if (_originalCoverImageUrl != null && _originalCoverImageUrl!.isNotEmpty) { urlsToDeleteFromStorage.add(_originalCoverImageUrl!); }
        finalCoverImageUrl = uploadedUrl;
      } else { uploadErrorOccurred = true; }
    } else if (coverImageUrlOrPath.value.isEmpty && _originalCoverImageUrl != null && _originalCoverImageUrl!.isNotEmpty) {
      urlsToDeleteFromStorage.add(_originalCoverImageUrl!);
      finalCoverImageUrl = null;
    }
    
    // 2. Menu Images
    List<String> finalMenuImageUrls = [];
    List<String> newMenuPathsToUpload = [];
    if (!uploadErrorOccurred) {
      for (var urlOrPath in menuImageUrlsOrPaths) {
        if (urlOrPath.startsWith('http')) { finalMenuImageUrls.add(urlOrPath); }
        else if (File(urlOrPath).existsSync()) { newMenuPathsToUpload.add(urlOrPath); }
      }
      for (var path in newMenuPathsToUpload) {
        final uploadedUrl = await _uploadRestaurantImage(path, currentUserId, 'menus');
        if (uploadedUrl != null) { finalMenuImageUrls.add(uploadedUrl); }
        else { uploadErrorOccurred = true; break; }
      }
      for (var originalUrl in _originalMenuImageUrls) {
        if (!finalMenuImageUrls.contains(originalUrl)) { urlsToDeleteFromStorage.add(originalUrl); }
      }
    }
    
    // 3. Banner Images
    List<String> finalBannerUrls = [];
    if (!uploadErrorOccurred && selectedBannerType.value == BannerType.image) {
      List<String> newBannerPathsToUpload = [];
      for (var urlOrPath in bannerImageUrlsOrPaths) {
        if (urlOrPath.startsWith('http')) { finalBannerUrls.add(urlOrPath); }
        else if (File(urlOrPath).existsSync()) { newBannerPathsToUpload.add(urlOrPath); }
      }
      for (var path in newBannerPathsToUpload) {
        final uploadedUrl = await _uploadRestaurantImage(path, currentUserId, 'promotions');
        if (uploadedUrl != null) { finalBannerUrls.add(uploadedUrl); }
        else { uploadErrorOccurred = true; break; }
      }
      for (var originalUrl in _originalBannerImageUrls) {
        if (!finalBannerUrls.contains(originalUrl)) { urlsToDeleteFromStorage.add(originalUrl); }
      }
    } else if (selectedBannerType.value == BannerType.text) {
      finalBannerUrls = bannerTextControllers.map((controller) => controller.text.trim()).where((text) => text.isNotEmpty).toList();
      urlsToDeleteFromStorage.addAll(_originalBannerImageUrls);
    }

    if (uploadErrorOccurred) {
      isLoading.value = false;
      Get.snackbar('บันทึกผิดพลาด', 'เกิดปัญหาขณะอัปโหลดรูปภาพ โปรดลองอีกครั้ง');
      return;
    }

    // 4. สร้าง newProposedData (JSONB)
    final double? newLatitude = double.tryParse(latitudeController.text);
    final double? newLongitude = double.tryParse(longitudeController.text);
    
    final Map<String, dynamic> newProposedData = {
        'owner_id': currentUserId, 
        'res_name': restaurantNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'detail': detailController.text.trim().isEmpty ? null : detailController.text.trim(),
        'opening_hours': openingHoursController.text.trim().isEmpty ? null : openingHoursController.text.trim(),
        'phone_no': phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
        'food_type': typeController.text.trim().isEmpty ? null : typeController.text.trim(), 
        'res_img': finalCoverImageUrl,
        'promo_imgs_urls': finalBannerUrls,
        'latitude': newLatitude, 
        'longitude': newLongitude, 
        'location': locationController.text.trim().isEmpty ? null : locationController.text.trim(),
        'status': 'pending', 
        'is_open': true, 
        'rating': 0.0, 
        'has_delivery': false, 
        'menus': finalMenuImageUrls.map((url) => {
             'img_url': [url], 
             'name': 'เมนู', 
             'price': 0 
         }).toList()
    };
    
    // 5. ส่งคำขอ UPDATE ไปยังตาราง restaurant_edits
    try {
      await supabase
        .from('restaurant_edits')
        .update({
          'proposed_data': newProposedData,
          'status': 'pending', // <<< เปลี่ยนสถานะกลับเป็น pending
          'rejection_reason': null, // <<< ล้างเหตุผลที่ถูกปฏิเสธ
        })
        .eq('id', requestEditId); // <<< อัปเดตแถวเดิม

      // (ลบรูปเก่าออกจาก Storage)
      await _deleteRestaurantImages(urlsToDeleteFromStorage);
      
      isLoading.value = false;
      Get.back(); // กลับไปหน้า MyShop
      
      // (สั่งให้ MyShopController โหลดข้อมูลใหม่)
      if (Get.isRegistered<MyShopController>()) {
          Get.find<MyShopController>().fetchMyRequests();
      }
      
      Get.snackbar(
        'ส่งคำขอสำเร็จ', 
        'ส่งคำขอแก้ไข/เพิ่มร้านค้าของคุณให้ Admin ตรวจสอบอีกครั้งแล้ว'
      );

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถส่งคำขอใหม่ได้: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    // Dispose Text Controllers
    for (var controller in bannerTextControllers) { controller.dispose(); }
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
}