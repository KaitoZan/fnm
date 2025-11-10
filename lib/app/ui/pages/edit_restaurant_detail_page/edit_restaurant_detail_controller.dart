// lib/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../restaurant_detail_page/restaurant_detail_controller.dart';

// <<<--- FIX 1: ย้าย export directive ขึ้นมาก่อน class/enum/declarations อื่นๆ ---
export 'package:food_near_me_app/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_controller.dart' show BannerType;
// ----------------------------------------------------------------------------------

// <<<--- FIX 2: ประกาศ enum BannerType ตามหลัง import/export directives ---
enum BannerType { image, text }
// ------------------------------------------------------------------------

class RestaurantEditDetailController extends GetxController {
 final String restaurantId; // String (uuid)
 late final FilterController _filterController;
 final supabase = Supabase.instance.client;

 // Controllers, State
 final Rx<Restaurant?> restaurantToEdit = Rx<Restaurant?>(null);
 final restaurantNameController = TextEditingController(); // res_name
 final descriptionController = TextEditingController(); // description
 final detailController = TextEditingController(); // สำหรับ detail
 final openingHoursController = TextEditingController();
 final phoneNumberController = TextEditingController(); // phone_no
 final locationController = TextEditingController(); // location (Text)
 final latitudeController = TextEditingController();
 final longitudeController = TextEditingController();
 final typeController = TextEditingController(); // UI สำหรับ food_type (Text)
 final RxBool isLoading = false.obs;
 final RxString coverImageUrlOrPath = ''.obs; // res_img
 final RxList<String> menuImageUrlsOrPaths = <String>[].obs; // menus.img_url
 final RxList<String> bannerImageUrlsOrPaths = <String>[].obs; // promo_imgs_urls

 // Original Data
 String? _originalCoverImageUrl;
 List<String> _originalMenuImageUrls = [];
 List<String> _originalBannerImageUrls = [];
 final Rx<BannerType> selectedBannerType = BannerType.image.obs;
 final RxList<TextEditingController> bannerTextControllers = <TextEditingController>[].obs;
 double? _originalLatitude;
 double? _originalLongitude;
 String _originalLocationText = '';

 RestaurantEditDetailController({required this.restaurantId});

 @override
 void onInit() {
 	super.onInit();
 	_filterController = Get.find<FilterController>();
 	_loadRestaurantData(); // โหลดข้อมูลร้านปัจจุบัน
 }

 @override
 void onClose() {
 	// Dispose Text Controllers ทั้งหมด
 	for (var controller in bannerTextControllers) {
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

 // --- 3. _loadRestaurantData (โหลด detail) ---
 void _loadRestaurantData() {
 	final foundRestaurant = _filterController.allRestaurantsObservable
 		.firstWhereOrNull((res) => res.id == restaurantId);

 	if (foundRestaurant != null) {
 	  restaurantToEdit.value = foundRestaurant;

 	  // โหลดข้อมูล Text Fields
 	  restaurantNameController.text = foundRestaurant.restaurantName;
 	  descriptionController.text = foundRestaurant.description;
 	  detailController.text = foundRestaurant.detail ?? ''; // โหลด detail
 	  openingHoursController.text = foundRestaurant.openingHours ?? '';
 	  phoneNumberController.text = foundRestaurant.phoneNumber ?? '';
 	  locationController.text = foundRestaurant.location ?? '';
 	  latitudeController.text = foundRestaurant.latitude?.toString() ?? '';
 	  longitudeController.text = foundRestaurant.longitude?.toString() ?? '';
 	  
 	  typeController.text = foundRestaurant.type ?? ''; // food_type (Text)

 	  // (เก็บค่า Location เดิม)
 	  _originalLatitude = foundRestaurant.latitude;
 	  _originalLongitude = foundRestaurant.longitude;
 	  _originalLocationText = foundRestaurant.location ?? '';

 	  // (โหลด URL รูปภาพ)
 	  coverImageUrlOrPath.value = foundRestaurant.imageUrl ?? '';
 	  _originalCoverImageUrl = foundRestaurant.imageUrl;
 	  menuImageUrlsOrPaths.assignAll(foundRestaurant.menuImages);
 	  _originalMenuImageUrls = List.from(foundRestaurant.menuImages);

 	  // (โหลดข้อมูลโปรโมชั่น)
 	  bool isImageBanner = foundRestaurant.promotion.isNotEmpty &&
 		  (foundRestaurant.promotion.any((url) => url.startsWith('http')));

 	  if (isImageBanner) {
 		selectedBannerType.value = BannerType.image;
 		bannerImageUrlsOrPaths.assignAll(_originalBannerImageUrls = List.from(foundRestaurant.promotion));
 		for (var controller in bannerTextControllers) { controller.dispose(); }
 		bannerTextControllers.clear();
 	  } else { // เป็น Text หรือ ไม่มีข้อมูล
 		selectedBannerType.value = BannerType.text;
 		bannerImageUrlsOrPaths.clear();
 		_originalBannerImageUrls = [];
 		for (var controller in bannerTextControllers) { controller.dispose(); }
 		bannerTextControllers.assignAll(foundRestaurant.promotion
 			.map((text) => TextEditingController(text: text))
 			.toList());
 	  }
 	} else {
 	  // กรณีไม่พบข้อมูลร้าน
 	  Get.snackbar('ข้อผิดพลาด', 'ไม่พบข้อมูลร้านค้า');
 	  Get.back();
 	}
 }

 // --- 4. ฟังก์ชันเลือกรูปภาพ (Private Helper) ---
 Future<void> _pickImages(ImageSource source, {required String imageType}) async {
 	  final ImagePicker picker = ImagePicker();
 	  if (imageType == 'cover') { // เลือกรูปเดียว
 		  final XFile? image = await picker.pickImage(source: source);
 		  if (image != null) {
 			  coverImageUrlOrPath.value = image.path; // อัปเดต State
 		  }
 	  } else { // เลือกหลายรูป (menu, promotion)
 		  final List<XFile> pickedFiles = await picker.pickMultiImage();
 		  if (pickedFiles.isNotEmpty) {
 			  final paths = pickedFiles.map((x) => x.path).toList();
 			  if (imageType == 'menu') {
 				  menuImageUrlsOrPaths.addAll(paths);
 			  } else if (imageType == 'promotion') {
 				  bannerImageUrlsOrPaths.addAll(paths);
 			  }
 		  }
 	  }
 }

 // --- 5. ฟังก์ชันเรียก BottomSheet (Private Helper) ---
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

 // --- 6. ฟังก์ชันปุ่มกดเลือกรูป (Public Access Functions) ---
 void pickCoverImage() => _showImagePickerBottomSheet(imageType: 'cover');
 void addMenuImages() => _showImagePickerBottomSheet(imageType: 'menu');
 void addPromotion() => _showImagePickerBottomSheet(imageType: 'promotion');

 // --- 7. ฟังก์ชันลบรูป (Public Access Functions) ---
 void removeCoverImage() => coverImageUrlOrPath.value = '';
 void removeMenuImage(int index) {
 	  if (index >= 0 && index < menuImageUrlsOrPaths.length) {
 		  menuImageUrlsOrPaths.removeAt(index);
 	  }
 }
 void removeBannerImage(int index) {
 	  if (index >= 0 && index < bannerImageUrlsOrPaths.length) {
 		  bannerImageUrlsOrPaths.removeAt(index);
 	  }
 }

 // --- 8. ฟังก์ชันจัดการ BannerType & Text Field (Public Access Functions) ---
 void setBannerType(BannerType type) {
 	selectedBannerType.value = type;
 	if (type == BannerType.image) {
 		for (var controller in bannerTextControllers) { controller.dispose(); }
 		bannerTextControllers.clear();
 	} else {
 		bannerImageUrlsOrPaths.clear();
 		final foundRestaurant = restaurantToEdit.value;
 		if(foundRestaurant != null && !foundRestaurant.promotion.any((url) => url.startsWith('http'))){
 			for (var controller in bannerTextControllers) { controller.dispose(); }
 			bannerTextControllers.assignAll(foundRestaurant.promotion.map((text) => TextEditingController(text: text)).toList());
 		} else if(bannerTextControllers.isEmpty) { 
            // กรณี Add New: ถ้าไม่มี fields เลย ให้เพิ่ม 1 field
            bannerTextControllers.add(TextEditingController());
        }
 	}
 }
 void addBannerField() {
 	bannerTextControllers.add(TextEditingController());
 }
 void removeBannerField(int index) {
 	if (index >= 0 && index < bannerTextControllers.length) {
 	  bannerTextControllers[index].dispose();
 	  bannerTextControllers.removeAt(index);
 	}
 }

 // --- 9. ฟังก์ชันอัปโหลดรูป (Private Helper) ---
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

 // --- 10. ฟังก์ชันลบรูป (Private Helper) ---
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
 				  } else { print("Could not extract path from URL: $url"); }
 			  } catch (e) { print("Error parsing URL to delete: $url, Error: $e"); }
 		  } else { print("Skipping deletion for invalid or non-storage URL: $url"); }
 	  }
 	  if (pathsToDelete.isNotEmpty) {
 		  try {
 			  final result = await supabase.storage.from('restaurant_images').remove(pathsToDelete);
 			  print("Deleted images from storage: $pathsToDelete, Result: $result");
 		  } catch (e) {
 			  print("Error deleting images from storage: $e");
 			  Get.snackbar('ลบรูปภาพผิดพลาด', 'ไม่สามารถลบรูปภาพบางส่วนออกจาก Storage ได้');
 	  }
 	  } else { print("No valid paths found to delete from storage."); }
 }

 // --- 11. saveChanges (Edit Mode) ---
 Future<void> saveChanges() async {
 	if (restaurantToEdit.value == null) return;
 	isLoading.value = true;
 	FocusScope.of(Get.context!).unfocus();

 	final String restaurantIdStr = restaurantToEdit.value!.id;

 	final double? newLatitude = double.tryParse(latitudeController.text);
 	final double? newLongitude = double.tryParse(longitudeController.text);
 	final String newLocationText = locationController.text;
 	bool locationChanged = (newLatitude != _originalLatitude || newLongitude != _originalLongitude || newLocationText != _originalLocationText);

 	// (ประมวลผลรูปภาพ - เหมือนเดิม)
 	List<String> urlsToDeleteFromStorage = [];
 	bool uploadErrorOccurred = false;
 	String? finalCoverImageUrl = _originalCoverImageUrl;
 	if (coverImageUrlOrPath.value.isNotEmpty && !coverImageUrlOrPath.value.startsWith('http')) {
 		final uploadedUrl = await _uploadRestaurantImage(coverImageUrlOrPath.value, restaurantIdStr, 'cover');
 		if (uploadedUrl != null) {
 			if (_originalCoverImageUrl != null && _originalCoverImageUrl!.isNotEmpty) { urlsToDeleteFromStorage.add(_originalCoverImageUrl!); }
 			finalCoverImageUrl = uploadedUrl;
 		} else { uploadErrorOccurred = true; }
 	} else if (coverImageUrlOrPath.value.isEmpty && _originalCoverImageUrl != null && _originalCoverImageUrl!.isNotEmpty) {
 		urlsToDeleteFromStorage.add(_originalCoverImageUrl!);
 		finalCoverImageUrl = null;
 	}
 	List<String> finalMenuImageUrls = [];
 	List<String> newMenuPathsToUpload = [];
 	if (!uploadErrorOccurred) {
 		for (var urlOrPath in menuImageUrlsOrPaths) {
 			if (urlOrPath.startsWith('http')) { finalMenuImageUrls.add(urlOrPath); }
 			else if (File(urlOrPath).existsSync()) { newMenuPathsToUpload.add(urlOrPath); }
 		}
 		for (var path in newMenuPathsToUpload) {
 			final uploadedUrl = await _uploadRestaurantImage(path, restaurantIdStr, 'menus');
 			if (uploadedUrl != null) { finalMenuImageUrls.add(uploadedUrl); }
 			else { uploadErrorOccurred = true; break; }
 		}
 		for (var originalUrl in _originalMenuImageUrls) {
 			if (!finalMenuImageUrls.contains(originalUrl)) { urlsToDeleteFromStorage.add(originalUrl); }
 		}
 	}
 	List<String> finalBannerUrls = [];
 	if (!uploadErrorOccurred && selectedBannerType.value == BannerType.image) {
 		List<String> newBannerPathsToUpload = [];
 		for (var urlOrPath in bannerImageUrlsOrPaths) {
 			if (urlOrPath.startsWith('http')) { finalBannerUrls.add(urlOrPath); }
 			else if (File(urlOrPath).existsSync()) { newBannerPathsToUpload.add(urlOrPath); }
 		}
 		for (var path in newBannerPathsToUpload) {
 			final uploadedUrl = await _uploadRestaurantImage(path, restaurantIdStr, 'promotions');
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

 	// --- 12. เตรียมข้อมูล (เปลี่ยน 'description_inside' เป็น 'detail') ---
 	Map<String, dynamic> commonUpdateData = {
 		'res_name': restaurantNameController.text.trim(),
 		'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
 		// 'description_inside': detailController.text.trim().isEmpty ? null : detailController.text.trim(), // <<<--- แก้ไข
 		'detail': detailController.text.trim().isEmpty ? null : detailController.text.trim(), // <<<--- TASK 3
 		'opening_hours': openingHoursController.text.trim().isEmpty ? null : openingHoursController.text.trim(),
 		'phone_no': phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
 		'food_type': typeController.text.trim().isEmpty ? null : typeController.text.trim(), // food_type (Text)
 		'res_img': finalCoverImageUrl,
 		'promo_imgs_urls': finalBannerUrls,
 		'is_open': restaurantToEdit.value!.isOpen.value,
 	};

 	try {
 		if (locationChanged) {
 			// (Insert restaurant_edits - เหมือนเดิม)
 			await supabase.from('restaurant_edits').insert({
 				'user_id': supabase.auth.currentUser!.id,
 				'res_id': restaurantIdStr,
 				'edit_type': 'update_location',
 				'proposed_data': {
 					'latitude': newLatitude,
 					'longitude': newLongitude,
 					'location': newLocationText.trim().isEmpty ? null : newLocationText.trim(),
 					...commonUpdateData
 				},
 				'status': 'pending',
 			});
 			await supabase.from('restaurants').update(commonUpdateData).eq('id', restaurantIdStr);
 			_updateLocalData(commonUpdateData, locationChanged: true, menuUrls: finalMenuImageUrls);
 			Get.snackbar('ส่งคำขอสำเร็จ', 'คำขอแก้ไขตำแหน่งร้านได้ถูกส่งให้ Admin ตรวจสอบแล้ว ข้อมูลอื่นๆ ถูกบันทึกแล้ว');

 		} else {
 			// (Update restaurants - เหมือนเดิม)
 			await supabase.from('restaurants').update({
 				...commonUpdateData,
 				if (newLocationText != _originalLocationText)
 					'location': newLocationText.trim().isEmpty ? null : newLocationText.trim(),
 			}).eq('id', restaurantIdStr);
 			_updateLocalData(commonUpdateData, locationChanged: false, menuUrls: finalMenuImageUrls);
 			Get.snackbar('สำเร็จ', 'บันทึกข้อมูลร้านค้าเรียบร้อยแล้ว');
    500.milliseconds.delay(); 
    Get.back();
 		}

 		// --- 13. อัปเดตเมนู (FIX: ห่อ URL ใน List<String> สำหรับ img_url) ---
 		await supabase.from('menus').delete().eq('res_id', restaurantIdStr);
 		if (finalMenuImageUrls.isNotEmpty) {
 			final List<Map<String, dynamic>> newMenusData = finalMenuImageUrls.map((url) => {
 				'res_id': restaurantIdStr,
 				'img_url': [url], // <<<--- FIX: ห่อ URL ด้วย List[]
 				'name': 'เมนู',
 				'price': 0
 			}).toList();
 			await supabase.from('menus').insert(newMenusData);
 		}

 		await _deleteRestaurantImages(urlsToDeleteFromStorage); // ลบรูปเก่า
 		Get.back(); // กลับหน้า Detail

 		// (รีเฟรชหน้า Detail - เหมือนเดิม)
 		if (Get.isRegistered<RestaurantDetailController>(tag: restaurantId)) {
 			final detailController = Get.find<RestaurantDetailController>(tag: restaurantId);
 			detailController.restore();
 		}

 	} on PostgrestException catch (e) {
        print("Error saving restaurant changes: ${e.toString()}");
        Get.snackbar(
          'ข้อผิดพลาด (DB)',
          'บันทึกข้อมูลไม่สำเร็จ: ${e.message}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(milliseconds: 2000),
        );
 	} catch (e) {
 	  print("Error saving restaurant changes: $e");
 	  Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถบันทึกข้อมูลร้านค้าได้: ${e.toString()}');
 	} finally {
 	  isLoading.value = false;
 	}
 }


  // --- 14. _updateLocalData (อัปเดต detail) ---
 void _updateLocalData(Map<String, dynamic> updatedData, {required bool locationChanged, required List<String> menuUrls}) {
 	 final currentRestaurant = restaurantToEdit.value;
 	 if (currentRestaurant == null) return;

 	 final updatedRestaurantModel = currentRestaurant.copyWith(
 	   restaurantName: updatedData['res_name'],
 	   description: updatedData['description'],
 	   // detail: updatedData['description_inside'], // <<<--- แก้ไข
 	   detail: updatedData['detail'], // <<<--- TASK 3
 	   openingHours: updatedData['opening_hours']?.toString(),
 	   phoneNumber: updatedData['phone_no'],
 	   type: updatedData['food_type'], // type (String?)
 	   imageUrl: updatedData['res_img'],
 	   promotion: List<String>.from(updatedData['promo_imgs_urls'] ?? []),
 	   isOpen: updatedData['is_open'],
 	   menuImages: menuUrls,
 	   latitude: locationChanged ? currentRestaurant.latitude : (double.tryParse(latitudeController.text) ?? currentRestaurant.latitude),
 	   longitude: locationChanged ? currentRestaurant.longitude : (double.tryParse(longitudeController.text) ?? currentRestaurant.longitude),
 	   location: locationChanged ? currentRestaurant.location : locationController.text,
 	 );

 	 _filterController.updateRestaurantInList(updatedRestaurantModel);
 	
 	 coverImageUrlOrPath.value = updatedRestaurantModel.imageUrl ?? '';
 	 _originalCoverImageUrl = updatedRestaurantModel.imageUrl;
 	 menuImageUrlsOrPaths.assignAll(updatedRestaurantModel.menuImages);
 	 _originalMenuImageUrls = List.from(updatedRestaurantModel.menuImages);
 	 if (selectedBannerType.value == BannerType.image) {
 	   bannerImageUrlsOrPaths.assignAll(updatedRestaurantModel.promotion);
 	   _originalBannerImageUrls = List.from(updatedRestaurantModel.promotion);
 	 } else {
 		 for (var controller in bannerTextControllers) { controller.dispose(); }
 		 bannerTextControllers.assignAll(updatedRestaurantModel.promotion.map((text) => TextEditingController(text: text)).toList());
 	 }
 	 if (!locationChanged) {
 		 _originalLatitude = updatedRestaurantModel.latitude;
 		 _originalLongitude = updatedRestaurantModel.longitude;
 		 _originalLocationText = updatedRestaurantModel.location ?? '';
 	 }
  }
} // End of Controller