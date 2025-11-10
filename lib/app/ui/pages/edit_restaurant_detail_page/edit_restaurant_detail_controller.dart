// lib/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../../../model/menu_item.dart'; 
import '../restaurant_detail_page/restaurant_detail_controller.dart';

export 'package:food_near_me_app/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_controller.dart' show BannerType, MenuItemController;

enum BannerType { image, text }

class MenuItemController {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final int? originalId; 

  MenuItemController({String name = '', String price = '', this.originalId})
      : nameController = TextEditingController(text: name),
        priceController = TextEditingController(text: price);
  
  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}


class RestaurantEditDetailController extends GetxController {
 final String restaurantId; 
 late final FilterController _filterController;
 final supabase = Supabase.instance.client;

 // Controllers, State
 final Rx<Restaurant?> restaurantToEdit = Rx<Restaurant?>(null);
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

 // <<<--- [TASK 16.11a - 1. เพิ่ม] State สำหรับ Checkboxes
 final RxBool hasDelivery = false.obs;
 final RxBool hasDineIn = false.obs;
 // <<<--- [สิ้นสุดการเพิ่ม]

 // Original Data
 String? _originalCoverImageUrl;
 List<String> _originalGalleryImageUrls = []; 
 List<String> _originalPromotionImageUrls = []; 
 
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
 	_loadRestaurantData(); 
 }

 @override
 void onClose() {
 	for (var controller in bannerTextControllers) {
 	  controller.dispose();
 	}
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

 // --- [TASK 16.11a - 2. แก้ไข] _loadRestaurantData
 void _loadRestaurantData() {
 	final foundRestaurant = _filterController.allRestaurantsObservable
 		.firstWhereOrNull((res) => res.id == restaurantId);

 	if (foundRestaurant != null) {
 	  restaurantToEdit.value = foundRestaurant;

 	  // (โหลดข้อมูล Text Fields)
 	  restaurantNameController.text = foundRestaurant.restaurantName;
 	  descriptionController.text = foundRestaurant.description;
 	  detailController.text = foundRestaurant.detail ?? ''; 
 	  openingHoursController.text = foundRestaurant.openingHours ?? '';
 	  phoneNumberController.text = foundRestaurant.phoneNumber ?? '';
 	  locationController.text = foundRestaurant.location ?? '';
 	  latitudeController.text = foundRestaurant.latitude?.toString() ?? '';
 	  longitudeController.text = foundRestaurant.longitude?.toString() ?? '';
 	  typeController.text = foundRestaurant.type ?? ''; 
 	  _originalLatitude = foundRestaurant.latitude;
 	  _originalLongitude = foundRestaurant.longitude;
 	  _originalLocationText = foundRestaurant.location ?? '';

 	  // (โหลด URL รูปหน้าปก)
 	  coverImageUrlOrPath.value = foundRestaurant.imageUrl ?? '';
 	  _originalCoverImageUrl = foundRestaurant.imageUrl;
   
    // (โหลด Menu Controllers)
    menuControllers.assignAll(foundRestaurant.menuItems.map((item) {
        return MenuItemController(
          name: item.name,
          price: item.price > 0 ? item.price.toStringAsFixed(0) : '',
          originalId: item.id
        );
    }).toList());

    // (โหลด Gallery)
    galleryImageUrlsOrPaths.assignAll(foundRestaurant.galleryImages);
    _originalGalleryImageUrls = List.from(foundRestaurant.galleryImages);

    // <<<--- [TASK 16.11a - 3. เพิ่ม] โหลด Checkboxes
    hasDelivery.value = foundRestaurant.hasDelivery;
    hasDineIn.value = foundRestaurant.hasDineIn;
    // <<<--- [สิ้นสุดการเพิ่ม]

 	  // (โหลดข้อมูลโปรโมชั่น)
 	  bool isImageBanner = foundRestaurant.promotion.isNotEmpty &&
 		  (foundRestaurant.promotion.any((url) => url.startsWith('http')));

 	  if (isImageBanner) {
 		  selectedBannerType.value = BannerType.image;
 		  promotionImageUrlsOrPaths.assignAll(_originalPromotionImageUrls = List.from(foundRestaurant.promotion));
 		  for (var controller in bannerTextControllers) { controller.dispose(); }
 		  bannerTextControllers.clear();
 	  } else { 
 		  selectedBannerType.value = BannerType.text;
 		  promotionImageUrlsOrPaths.clear(); 
 		  _originalPromotionImageUrls = []; 
 		  for (var controller in bannerTextControllers) { controller.dispose(); }
 		  bannerTextControllers.assignAll(foundRestaurant.promotion
 			.map((text) => TextEditingController(text: text))
 			.toList());
 	  }
 	} else {
 	  Get.snackbar('ข้อผิดพลาด', 'ไม่พบข้อมูลร้านค้า');
 	  Get.back();
 	}
 }

 // (ฟังก์ชันเลือกรูปภาพ _pickImages)
 Future<void> _pickImages(ImageSource source, {required String imageType}) async {
 	  final ImagePicker picker = ImagePicker();
 	  if (imageType == 'cover') { 
 		  final XFile? image = await picker.pickImage(source: source);
 		  if (image != null) {
 			  coverImageUrlOrPath.value = image.path; 
 		  }
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
 
 // (ฟังก์ชัน _showImagePickerBottomSheet)
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

 // (ฟังก์ชันลบรูป)
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

 // (ฟังก์ชันจัดการ BannerType)
 void setBannerType(BannerType type) {
 	selectedBannerType.value = type;
 	if (type == BannerType.image) {
 		for (var controller in bannerTextControllers) { controller.dispose(); }
 		bannerTextControllers.clear();
 	} else {
 		promotionImageUrlsOrPaths.clear(); 
 		final foundRestaurant = restaurantToEdit.value;
 		if(foundRestaurant != null && !foundRestaurant.promotion.any((url) => url.startsWith('http'))){
 			for (var controller in bannerTextControllers) { controller.dispose(); }
 			bannerTextControllers.assignAll(foundRestaurant.promotion.map((text) => TextEditingController(text: text)).toList());
 		} else if(bannerTextControllers.isEmpty) { 
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

 // (ฟังก์ชันลบรูป)
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

 // --- [TASK 16.11a - 4. แก้ไข] saveChanges (Edit Mode)
 Future<void> saveChanges() async {
 	if (restaurantToEdit.value == null) return;
 	isLoading.value = true;
 	FocusScope.of(Get.context!).unfocus();

 	final String restaurantIdStr = restaurantToEdit.value!.id;

 	final double? newLatitude = double.tryParse(latitudeController.text);
 	final double? newLongitude = double.tryParse(longitudeController.text);
 	final String newLocationText = locationController.text;
 	bool locationChanged = (newLatitude != _originalLatitude || newLongitude != _originalLongitude || newLocationText != _originalLocationText);

 	// (ประมวลผลรูปภาพ - Cover Image)
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

  // (การประมวลผล Gallery)
 	List<String> finalGalleryUrls = []; 
 	if (!uploadErrorOccurred) {
 		List<String> newGalleryPathsToUpload = []; 
 		for (var urlOrPath in galleryImageUrlsOrPaths) { 
 			if (urlOrPath.startsWith('http')) { finalGalleryUrls.add(urlOrPath); }
 			else if (File(urlOrPath).existsSync()) { newGalleryPathsToUpload.add(urlOrPath); } 
 		}
 		for (var path in newGalleryPathsToUpload) { 
 			final uploadedUrl = await _uploadRestaurantImage(path, restaurantIdStr, 'gallery'); 
 			if (uploadedUrl != null) { finalGalleryUrls.add(uploadedUrl); }
 			else { uploadErrorOccurred = true; break; }
 		}
 		for (var originalUrl in _originalGalleryImageUrls) { 
 			if (!finalGalleryUrls.contains(originalUrl)) { urlsToDeleteFromStorage.add(originalUrl); }
 		}
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
 			final uploadedUrl = await _uploadRestaurantImage(path, restaurantIdStr, 'promotions'); 
 			if (uploadedUrl != null) { finalPromotionUrlsOrText.add(uploadedUrl); }
 			else { uploadErrorOccurred = true; break; }
 		}
 		for (var originalUrl in _originalPromotionImageUrls) { 
 			if (!finalPromotionUrlsOrText.contains(originalUrl)) { urlsToDeleteFromStorage.add(originalUrl); }
 		}
 	} else if (selectedBannerType.value == BannerType.text) {
 		finalPromotionUrlsOrText = bannerTextControllers.map((controller) => controller.text.trim()).where((text) => text.isNotEmpty).toList(); 
 		urlsToDeleteFromStorage.addAll(_originalPromotionImageUrls); 
 	}

 	if (uploadErrorOccurred) {
 		isLoading.value = false;
 		Get.snackbar('บันทึกผิดพลาด', 'เกิดปัญหาขณะอัปโหลดรูปภาพ โปรดลองอีกครั้ง');
 		return;
 	}

 	// --- [TASK 16.11a - 5. แก้ไข] commonUpdateData
 	Map<String, dynamic> commonUpdateData = {
 		'res_name': restaurantNameController.text.trim(),
 		'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
 		'detail': detailController.text.trim().isEmpty ? null : detailController.text.trim(), 
 		'opening_hours': openingHoursController.text.trim().isEmpty ? null : openingHoursController.text.trim(),
 		'phone_no': phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
 		'food_type': typeController.text.trim().isEmpty ? null : typeController.text.trim(), 
 		'res_img': finalCoverImageUrl,
    'gallery_imgs_urls': finalGalleryUrls, 
 		'promo_imgs_urls': finalPromotionUrlsOrText, 
 		'is_open': restaurantToEdit.value!.isOpen.value,
    'has_delivery': hasDelivery.value, // <<< [เพิ่ม]
    'has_dine_in': hasDineIn.value,   // <<< [เพิ่ม]
 	};

 	try {
 		if (locationChanged) {
 			// --- [TASK 16.11a - 6. แก้ไข] proposed_data
 			await supabase.from('restaurant_edits').insert({
 				'user_id': supabase.auth.currentUser!.id,
 				'res_id': restaurantIdStr,
 				'edit_type': 'update_location',
 				'proposed_data': {
 					'latitude': newLatitude,
 					'longitude': newLongitude,
 					'location': newLocationText.trim().isEmpty ? null : newLocationText.trim(),
 					...commonUpdateData,
          'menus': finalMenuItemsData, 
 				},
 				'status': 'pending',
 			});
 			await supabase.from('restaurants').update(commonUpdateData).eq('id', restaurantIdStr);
      await _updateMenus(restaurantIdStr, finalMenuItemsData); 
 			_updateLocalData(commonUpdateData, locationChanged: true, menuData: finalMenuItemsData);
      
      await _deleteRestaurantImages(urlsToDeleteFromStorage); 
 			Get.back(); 
 			Get.snackbar('ส่งคำขอสำเร็จ', 'คำขอแก้ไขตำแหน่งร้านได้ถูกส่งให้ Admin ตรวจสอบแล้ว ข้อมูลอื่นๆ ถูกบันทึกแล้ว');

 		} else {
 			// (Update restaurants)
 			await supabase.from('restaurants').update({
 				...commonUpdateData,
 				if (newLocationText != _originalLocationText)
 					'location': newLocationText.trim().isEmpty ? null : newLocationText.trim(),
 			}).eq('id', restaurantIdStr);
      
      await _updateMenus(restaurantIdStr, finalMenuItemsData);
 			_updateLocalData(commonUpdateData, locationChanged: false, menuData: finalMenuItemsData);
      await _deleteRestaurantImages(urlsToDeleteFromStorage);
 			
      Get.back();
 			Get.snackbar('สำเร็จ', 'บันทึกข้อมูลร้านค้าเรียบร้อยแล้ว');
 		}

 		// (รีเฟรชหน้า Detail)
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


  // (Helper _updateMenus)
  Future<void> _updateMenus(String restaurantIdStr, List<Map<String, dynamic>> newMenusData) async {
      await supabase.from('menus').delete().eq('res_id', restaurantIdStr);
 		  if (newMenusData.isNotEmpty) {
 			  final List<Map<String, dynamic>> newMenusWithId = newMenusData.map((menu) {
            return {
              ...menu,
              'res_id': restaurantIdStr, 
            };
        }).toList();
 			  await supabase.from('menus').insert(newMenusWithId);
 		  }
  }

  // --- [TASK 16.11a - 7. แก้ไข] _updateLocalData
 void _updateLocalData(Map<String, dynamic> updatedData, {required bool locationChanged, required List<Map<String, dynamic>> menuData}) {
 	 final currentRestaurant = restaurantToEdit.value;
 	 if (currentRestaurant == null) return;

   final List<MenuItem> updatedMenuItems = menuData.map((map) {
      return MenuItem.fromMap({ 
        'id': 0, 
        'name': map['name'],
        'price': map['price'],
      });
   }).toList();
   
 	 final updatedRestaurantModel = currentRestaurant.copyWith(
 	   restaurantName: updatedData['res_name'],
 	   description: updatedData['description'],
 	   detail: updatedData['detail'], 
 	   openingHours: updatedData['opening_hours']?.toString(),
 	   phoneNumber: updatedData['phone_no'],
 	   type: updatedData['food_type'], 
 	   imageUrl: updatedData['res_img'],
 	   promotion: List<String>.from(updatedData['promo_imgs_urls'] ?? []),
     galleryImages: List<String>.from(updatedData['gallery_imgs_urls'] ?? []), 
 	   isOpen: updatedData['is_open'],
     hasDelivery: updatedData['has_delivery'], // <<< [เพิ่ม]
     hasDineIn: updatedData['has_dine_in'],   // <<< [เพิ่ม]
 	   menuItems: updatedMenuItems,
 	   latitude: locationChanged ? currentRestaurant.latitude : (double.tryParse(latitudeController.text) ?? currentRestaurant.latitude),
 	   longitude: locationChanged ? currentRestaurant.longitude : (double.tryParse(longitudeController.text) ?? currentRestaurant.longitude),
 	   location: locationChanged ? currentRestaurant.location : locationController.text,
 	 );

 	 _filterController.updateRestaurantInList(updatedRestaurantModel);
 	
 	 coverImageUrlOrPath.value = updatedRestaurantModel.imageUrl ?? '';
 	 _originalCoverImageUrl = updatedRestaurantModel.imageUrl;
   
    // (อัปเดต menuControllers)
    for (var controller in menuControllers) { controller.dispose(); }
    menuControllers.assignAll(updatedMenuItems.map((item) {
        return MenuItemController(
          name: item.name,
          price: item.price > 0 ? item.price.toStringAsFixed(0) : '',
          originalId: item.id
        );
    }).toList());
    
    // (อัปเดต Gallery)
    galleryImageUrlsOrPaths.assignAll(updatedRestaurantModel.galleryImages); 
    _originalGalleryImageUrls = List.from(updatedRestaurantModel.galleryImages); 

    // <<<--- [TASK 16.11a - 8. เพิ่ม] อัปเดต State Checkboxes
    hasDelivery.value = updatedRestaurantModel.hasDelivery;
    hasDineIn.value = updatedRestaurantModel.hasDineIn;
    // <<<--- [สิ้นสุดการเพิ่ม]

 	 if (selectedBannerType.value == BannerType.image) {
 	   promotionImageUrlsOrPaths.assignAll(updatedRestaurantModel.promotion); 
 	   _originalPromotionImageUrls = List.from(updatedRestaurantModel.promotion); 
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