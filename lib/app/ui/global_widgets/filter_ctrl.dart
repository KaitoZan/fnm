// lib/app/ui/global_widgets/filter_ctrl.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/services/location_service.dart';
import '../../model/restaurant.dart';
import '../pages/home_page/widgets/home_localist.dart';
import '../pages/login_page/login_controller.dart';

class FilterController extends GetxController {
  // ... (Controllers Search) ...
  final TextEditingController homeSearchInputController =
      TextEditingController();
  final RxString homeSearchQuery = ''.obs;
  late FocusNode homeSearchFocusNode;
  final TextEditingController favSearchInputController =
      TextEditingController();
  final RxString favSearchQuery = ''.obs;
  late FocusNode favSearchFocusNode;

  // State Filters
  final RxString selectedProvince = ''.obs;
  final RxString selectedDistrict = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString openStatusFilter = 'all'.obs;

  // Controllers อื่นๆ
  late final LoginController _loginController;
  late final LocationService locationService; // <<<--- FIX: ประกาศ locationService (Public)

  // State Lists ร้านอาหาร
  final RxList<Restaurant> allRestaurantsObservable = <Restaurant>[].obs;
  final RxList<Restaurant> filteredRestaurantList = <Restaurant>[].obs;
  final RxList<Restaurant> filteredFavoriteList = <Restaurant>[].obs;

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    homeSearchFocusNode = FocusNode();
    favSearchFocusNode = FocusNode();
    _loginController = Get.find<LoginController>();
    locationService = Get.find<LocationService>(); // <<<--- FIX: Find locationService

    initializeAllRestaurants(); // โหลดร้านเริ่มต้น

    // Listeners Search
    homeSearchInputController.addListener(() {
      homeSearchQuery.value = homeSearchInputController.text;
      applyFilters();
    });
    favSearchInputController.addListener(() {
      favSearchQuery.value = favSearchInputController.text;
      applyFilters();
    });

    // Listeners อื่นๆ
    ever(_loginController.userFavoriteList, _updateFavoriteStatuses);
    ever(locationService.currentLocation, (_) => applyFilters()); // <<<--- ใช้ locationService
    ever(openStatusFilter, (_) => applyFilters());
    ever(selectedProvince, (_) => applyFilters());
    ever(selectedDistrict, (_) => applyFilters());
    ever(selectedCategory, (_) => applyFilters());
  }

  // ดึงตำแหน่ง
  void fetchCurrentLocation() {
    locationService.determinePosition(); // <<<--- ใช้ locationService
  }

  RxBool get isLoadingLocation => locationService.isLoadingLocation; // <<<--- ใช้ locationService
  String get currentAddress => locationService.currentAddress.value; // <<<--- ใช้ locationService

  // ... (ส่วนที่เหลือของ FilterController เหมือนเดิม)
  // ...
  
  // โหลดร้านอาหารเริ่มต้น
  Future<void> initializeAllRestaurants() async {
    try {
      // --- 1. Select (ใช้ menus(img_url)) ---
      final List<Map<String, dynamic>> data = await supabase
          .from('restaurants')
          .select(
            '*, menus(id, res_id, name, description, price, img_url)',
          ) // <<<--- menus(..., img_url)
          .eq('status', 'approved');

      final List<Restaurant> tempRestaurants = data.map((map) {
        // --- 2. เช็ค Favorite (ใช้ ID String) ---
        final bool isCurrentlyFavorite =
            _loginController.isLoggedIn.value &&
            _loginController.userFavoriteList.contains(
              map['id'] as String? ?? '',
            ); // <<<--- ID (String)

        // --- 3. สร้าง Object (ใช้ Model ที่แก้แล้ว) ---
        return Restaurant.fromSupabaseMap(map, isCurrentlyFavorite);
      }).toList();

      allRestaurantsObservable.assignAll(tempRestaurants);
      applyFilters(); // กรองครั้งแรก
    } catch (e) {
      // จัดการ Error
      print("Error loading restaurants: $e");
      Get.snackbar(
        "ข้อผิดพลาด",
        "ไม่สามารถโหลดข้อมูลร้านอาหารได้: ${e.toString()}",
      );
      allRestaurantsObservable.clear();
      filteredRestaurantList.clear();
      filteredFavoriteList.clear();
    }
  }
  
  // (Omitted _updateFavoriteStatuses, onClose, clearSearchFocus, setSelected*, toggleFavorite, updateRestaurantInList for brevity - they remain unchanged)
  void _updateFavoriteStatuses([List<String>? newFavoriteList]) {
    final favorites = newFavoriteList ?? _loginController.userFavoriteList;
    bool changed = false;
    for (var restaurant in allRestaurantsObservable) {
      bool shouldBeFavorite = favorites.contains(
        restaurant.id,
      );
      if (restaurant.isFavorite.value != shouldBeFavorite) {
        restaurant.isFavorite.value = shouldBeFavorite;
        changed = true;
      }
    }
    if (changed) {
      applyFilters();
    }
  }

  @override
  void onClose() {
    homeSearchInputController.dispose();
    homeSearchFocusNode.dispose();
    favSearchInputController.dispose();
    favSearchFocusNode.dispose();
    super.onClose();
  }

  void clearSearchFocus(String page) {
    if (page == 'home') {
      homeSearchFocusNode.unfocus();
    } else if (page == 'favorite') {
      favSearchFocusNode.unfocus();
    }
  }

  void setSelectedProvince(String province) {
    selectedProvince.value = province;
    selectedDistrict.value = '';
  }

  void setSelectedDistrict(String district) {
    selectedDistrict.value = district;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavorite(String restaurantId) async {
    if (!_loginController.isLoggedIn.value) {
      Get.snackbar('System', 'กรุณาเข้าสู่ระบบ...');
      return;
    }

    final String currentUserId = _loginController.userId.value;

    try {
      if (_loginController.userFavoriteList.contains(restaurantId)) {
        await supabase.from('favorite_restaurants').delete().match({
          'user_id': currentUserId,
          'res_id': restaurantId,
        });

        _loginController.userFavoriteList.remove(restaurantId);
        Get.snackbar('รายการโปรด', 'ลบออกจากรายการโปรดแล้ว');
      } else {
        await supabase.from('favorite_restaurants').insert({
          'user_id': currentUserId,
          'res_id': restaurantId,
        });

        _loginController.userFavoriteList.add(restaurantId);
        Get.snackbar('รายการโปรด', 'เพิ่มในรายการโปรดแล้ว');
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถอัปเดตรายการโปรดได้: ${e.toString()}',
      );
    }
  }

  void updateRestaurantInList(Restaurant updatedRestaurant) {
    final int index = allRestaurantsObservable.indexWhere(
      (res) => res.id == updatedRestaurant.id,
    );
    if (index != -1) {
      bool currentFav = allRestaurantsObservable[index].isFavorite.value;
      bool currentOpen = allRestaurantsObservable[index].isOpen.value;
      allRestaurantsObservable[index] = updatedRestaurant;
      allRestaurantsObservable[index].isFavorite.value = currentFav;
      allRestaurantsObservable[index].isOpen.value = currentOpen;
      applyFilters();
    }
  }

  void applyFilters() {
    List<Restaurant> tempFilteredRestaurants = List.from(
      allRestaurantsObservable,
    );
    final Position? userPosition = locationService.currentLocation.value;

    // --- [แก้ไข] STEP 1: คำนวณระยะทาง (ถ้ามีตำแหน่ง) หรือรีเซ็ต (ถ้าไม่มี) ---
    if (userPosition != null) {
      for (var restaurant in tempFilteredRestaurants) {
        if (restaurant.latitude != null && restaurant.longitude != null) {
          final double distance = Geolocator.distanceBetween(
            userPosition.latitude,
            userPosition.longitude,
            restaurant.latitude!,
            restaurant.longitude!,
          );
          restaurant.distanceInMeters = distance;
        } else {
          restaurant.distanceInMeters = double.maxFinite;
        }
      }
    } else {
      // ถ้าไม่มีตำแหน่ง ให้รีเซ็ตระยะทาง
      for (var restaurant in tempFilteredRestaurants) {
        restaurant.distanceInMeters = double.maxFinite;
      }
    }
    // --- [สิ้นสุด STEP 1] ---


    // --- [แก้ไข] STEP 2: กรอง (Filter) ข้อมูลทั้งหมดก่อน ---

    // กรองตาม Search (Home)
    if (homeSearchQuery.value.isNotEmpty) {
      final query = homeSearchQuery.value.toLowerCase();
      tempFilteredRestaurants = tempFilteredRestaurants
          .where(
            (r) =>
                (r.restaurantName.toLowerCase().contains(query)) ||
                (r.description.toLowerCase().contains(query)) ||
                (r.detail?.toLowerCase().contains(query) ?? false) ||
                (r.type?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    // กรองตาม จังหวัด/อำเภอ (ใช้ Text location)
    if (selectedProvince.value.isNotEmpty) {
      tempFilteredRestaurants = tempFilteredRestaurants.where((restaurant) {
        final String locString = restaurant.location ?? '';
        final bool isProvinceMatch = locString.toLowerCase().contains(
          selectedProvince.value.toLowerCase(),
        );
        if (selectedDistrict.value.isNotEmpty) {
          final bool isDistrictMatch = locString.toLowerCase().contains(
            selectedDistrict.value.toLowerCase(),
          );
          return isProvinceMatch && isDistrictMatch;
        }
        return isProvinceMatch;
      }).toList();
    }

    // กรองตาม ประเภทอาหาร (*** แก้ไข: ใช้ contains แทน == เพื่อรองรับ "อาหารไทย , อาหารตามสั่ง" ***)
    if (selectedCategory.value.isNotEmpty) {
      final catLower = selectedCategory.value.toLowerCase();
      tempFilteredRestaurants = tempFilteredRestaurants
          .where((r) => (r.type?.toLowerCase().contains(catLower) ?? false))
          .toList();
    }

    // กรองตาม สถานะเปิด/ปิด
    if (openStatusFilter.value != 'all') {
      final bool shouldBeOpen = openStatusFilter.value == 'open';
      tempFilteredRestaurants = tempFilteredRestaurants
          .where((r) => r.isOpen.value == shouldBeOpen)
          .toList();
    }

    // --- [เพิ่ม] กรองระยะทาง 15กม. (ถ้าใช้ตำแหน่ง) ---
    if (userPosition != null) {
      tempFilteredRestaurants = tempFilteredRestaurants
          .where((r) => r.distanceInMeters <= 15000) // 15,000 เมตร
          .toList();
    }
    // --- [สิ้นสุด STEP 2] ---


    // --- [แก้ไข] STEP 3: เรียงลำดับ (Sort) เป็นขั้นตอนสุดท้าย ---
    if (userPosition != null) {
      // ถ้ามีตำแหน่ง: เรียงตามระยะทาง
      tempFilteredRestaurants.sort(
        (a, b) => a.distanceInMeters.compareTo(b.distanceInMeters),
      );
    } else {
      // ถ้าไม่มีตำแหน่ง: เรียงตามชื่อ
      tempFilteredRestaurants.sort(
        (a, b) => a.restaurantName.compareTo(b.restaurantName),
      );
    }
    // --- [สิ้นสุด STEP 3] ---


    // อัปเดต List หน้า Home
    filteredRestaurantList.value = tempFilteredRestaurants;

    // --- กรองสำหรับหน้า Favorite ---
    List<Restaurant> tempFilteredFavorites = allRestaurantsObservable
        .where((restaurant) => restaurant.isFavorite.value)
        .toList();

    // กรองตาม Search (Favorite)
    if (favSearchQuery.value.isNotEmpty) {
      final favQuery = favSearchQuery.value.toLowerCase();
      tempFilteredFavorites = tempFilteredFavorites
          .where(
            (r) =>
                (r.restaurantName.toLowerCase().contains(favQuery)) ||
                (r.description.toLowerCase().contains(favQuery)) ||
                (r.detail?.toLowerCase().contains(favQuery) ?? false) ||
                (r.type?.toLowerCase().contains(favQuery) ?? false),
          )
          .toList();
    }
    // เรียง Favorite ตามชื่อร้าน
    tempFilteredFavorites.sort(
      (a, b) => a.restaurantName.compareTo(b.restaurantName),
    );

    // อัปเดต List หน้า Favorite
    filteredFavoriteList.value = tempFilteredFavorites;
  }

  // --- removeRestaurantFromList (เหมือนเดิม) ---
   void removeRestaurantFromList(String id) {
     allRestaurantsObservable.removeWhere((res) => res.id == id);
     applyFilters();
   }


}