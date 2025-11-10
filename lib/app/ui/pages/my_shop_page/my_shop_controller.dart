// lib/app/ui/pages/my_shop_page/my_shop_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../login_page/login_controller.dart';
import '../../../model/my_request_status.dart'; // <<< 1. Import Model ใหม่

// <<< 2. เพิ่ม Enum สำหรับสลับหน้า ---
enum MyShopView { shops, requests }

class MyShopController extends GetxController {
  // State: List ของร้านค้าที่ User คนนี้เป็นเจ้าของ
  final RxList<Restaurant> myOwnerShopList = <Restaurant>[].obs;

  // Controllers ที่ต้องใช้
  late final LoginController _loginController;
  late final FilterController _filterController;

  // Supabase client instance
  final supabase = Supabase.instance.client;

  // <<< 3. เพิ่ม State สำหรับหน้าใหม่ ---
  final Rx<MyShopView> currentView = MyShopView.shops.obs;
  final RxList<MyRequestStatus> myRequestList = <MyRequestStatus>[].obs;
  final RxBool isLoadingRequests = false.obs;
  // <<< สิ้นสุดการเพิ่ม State ---

  @override
  void onInit() {
    super.onInit();
    _loginController = Get.find<LoginController>();
    _filterController = Get.find<FilterController>();

    ever(_filterController.allRestaurantsObservable, (_) => filterMyShops());
    
    // <<< 4. แก้ไข ever() ของ userId ---
    ever(_loginController.userId, (_) {
      filterMyShops();
      fetchMyRequests(); // <<< เมื่อ User ID เปลี่ยน ให้ดึงคำร้องใหม่ด้วย
    });
    // <<< สิ้นสุดการแก้ไข ---

    filterMyShops();
    // <<< 5. เรียก fetchMyRequests() ครั้งแรก ---
    fetchMyRequests();
    // <<< สิ้นสุดการเรียก ---
  }
  
  // <<< 6. เพิ่มฟังก์ชันสลับ View ---
  void switchView(int index) {
    final newView = (index == 0) ? MyShopView.shops : MyShopView.requests;
    if (currentView.value != newView) {
      currentView.value = newView;
      if (newView == MyShopView.requests) {
        fetchMyRequests(); // << ดึงข้อมูลใหม่เมื่อสลับมาหน้านี้
      }
    }
  }
  // <<< สิ้นสุดฟังก์ชันสลับ View ---
  
  // <<< 7. เพิ่มฟังก์ชันดึงข้อมูลคำร้อง/รายงาน (ที่แก้ไข Query แล้ว) ---
  Future<void> fetchMyRequests() async {
    if (isLoadingRequests.value) return; 
    isLoadingRequests.value = true;

    try {
      final String currentUserId = _loginController.userId.value;
      if (currentUserId.isEmpty) {
        myRequestList.clear();
        isLoadingRequests.value = false;
        return;
      }

      // 1. ดึงข้อมูลคำขอแก้ไข (restaurant_edits)
      final editData = await supabase
          .from('restaurant_edits')
          .select("*, res_name_from_data:proposed_data->>res_name") // <<< ดึงชื่อร้านจาก JSONB
          .eq('user_id', currentUserId) 
          .order('created_at', ascending: false);

      // 2. ดึงข้อมูลการรายงาน (complaints) (Query แบบ JOIN)
      final complaintData = await supabase
          .from('complaints')
          .select('''
            *, 
            restaurants ( res_name ), 
            comments ( content )
          ''') // <<< JOIN restaurants และ comments
          .eq('reporter_id', currentUserId) 
          .order('created_at', ascending: false);

      // 3. Map ข้อมูลและรวม List
      final List<MyRequestStatus> requests = editData
          .map((map) => MyRequestStatus.fromRestaurantEdit(map))
          .toList();
      
      final List<MyRequestStatus> complaints = complaintData
          .map((map) => MyRequestStatus.fromComplaint(map))
          .toList();

      final combinedList = [...requests, ...complaints];

      // 4. เรียงลำดับตามวันที่
      combinedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      myRequestList.assignAll(combinedList);

    } catch (e) {
      print("Error fetching my requests: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถดึงข้อมูลคำร้องได้: ${e.toString()}');
    } finally {
      isLoadingRequests.value = false;
    }
  }
  // <<< สิ้นสุดฟังก์ชันดึงข้อมูล ---

  // (โค้ดเดิม... filterMyShops)
  void filterMyShops() {
    if (_loginController.isLoggedIn.value &&
        _loginController.userId.value.isNotEmpty) {
      final String currentOwnerId = _loginController.userId.value; 
      final filteredShops = _filterController.allRestaurantsObservable
          .where((restaurant) => restaurant.ownerId == currentOwnerId)
          .toList();
      myOwnerShopList.assignAll(filteredShops);
    } else {
      myOwnerShopList.clear();
    }
  }

  // (โค้ดเดิม... toggleShopStatus)
  void toggleShopStatus(String shopId, bool newStatus) async { 
    final shopIndex = myOwnerShopList.indexWhere((shop) => shop.id == shopId);
    if (shopIndex == -1) {
        Get.snackbar('ข้อผิดพลาด', 'ไม่พบร้านค้าในรายการ');
        return; 
    }
    final String restaurantName = myOwnerShopList[shopIndex].restaurantName;
    try {
      await supabase
          .from('restaurants')
          .update({'is_open': newStatus}) 
          .eq('id', shopId); 
       myOwnerShopList[shopIndex].isOpen.value = newStatus;
       Get.snackbar(
        'สถานะร้านค้า',
        newStatus
            ? 'ร้าน "$restaurantName" เปิดให้บริการแล้ว'
            : 'ร้าน "$restaurantName" ปิดให้บริการชั่วคราว',
         snackPosition: SnackPosition.TOP,
         backgroundColor: Colors.black.withOpacity(0.1),
         colorText: Colors.black,
         duration: const Duration(milliseconds: 1200),
       );
    } catch (e) {
       Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถอัปเดตสถานะร้าน "$restaurantName" ได้: ${e.toString()}',
         snackPosition: SnackPosition.TOP,
         backgroundColor: Colors.red.withOpacity(0.8),
         colorText: Colors.white,
       );
    }
  }
} // End of Controller