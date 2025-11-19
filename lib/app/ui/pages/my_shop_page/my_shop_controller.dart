// lib.zip/app/ui/pages/my_shop_page/my_shop_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../login_page/login_controller.dart';
import '../../../model/my_request_status.dart';
import '../../../model/notification_model.dart';

enum MyShopView { shops, requests }

class MyShopController extends GetxController {
  final RxList<Restaurant> myOwnerShopList = <Restaurant>[].obs;
  late final LoginController _loginController;
  late final FilterController _filterController;
  final supabase = Supabase.instance.client;
  final Rx<MyShopView> currentView = MyShopView.shops.obs;
  final RxList<MyRequestStatus> myRequestList = <MyRequestStatus>[].obs;
  final RxBool isLoadingRequests = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoadingNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loginController = Get.find<LoginController>();
    _filterController = Get.find<FilterController>();

    ever(_filterController.allRestaurantsObservable, (_) => filterMyShops());
    
    ever(_loginController.userId, (_) {
      filterMyShops(); 
      fetchMyRequests(); 
      fetchNotifications();
    });

    filterMyShops();
    fetchMyRequests();
    fetchNotifications();
  }
  
  Future<void> requestReapproval(String shopId) async {
    final shop = myOwnerShopList.firstWhereOrNull((res) => res.id == shopId);
    if (shop == null) return;
    if (_loginController.userId.value.isEmpty) return;

    Get.defaultDialog(
      title: "ยืนยันการส่งคำร้อง",
      middleText: "ร้าน ${shop.restaurantName} จะถูกส่งคำร้องให้ Admin ตรวจสอบเพื่อกลับมาแสดงในแอปอีกครั้ง",
      textConfirm: "ส่งคำร้อง",
      textCancel: "ยกเลิก",
      confirmTextColor: Colors.white,
      buttonColor: Colors.pink.shade400,
      onConfirm: () async {
        Get.back();
        Get.snackbar('กำลังดำเนินการ', 'กำลังส่งคำร้อง...', snackPosition: SnackPosition.TOP);

        try {
          final Map<String, dynamic> requestData = {
            'res_id': shopId,
            'owner_id': _loginController.userId.value,
            'res_name': shop.restaurantName,
          };

          await supabase
            .from('restaurant_edits')
            .insert({
              'user_id': _loginController.userId.value,
              'res_id': shopId,
              'edit_type': 'reapproval_from_suspended',
              'proposed_data': requestData,
              'status': 'pending',
            });
            
          await fetchMyRequests(); 
          
          Get.snackbar('สำเร็จ', 'ส่งคำร้องขออนุมัติซ้ำเรียบร้อยแล้ว Admin จะตรวจสอบเร็ว ๆ นี้');
          
        } catch (e) {
          Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถส่งคำร้องได้: ${e.toString()}');
        }
      },
    );
  }

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

  Future<void> fetchNotifications() async {
    final currentUserId = _loginController.userId.value;
    if (currentUserId.isEmpty || isLoadingNotifications.value) return;

    isLoadingNotifications.value = true;
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('notifications')
          .select('*')
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      notifications.assignAll(data.map((map) => NotificationModel.fromMap(map)).toList());
      
      unreadCount.value = notifications.where((n) => !n.isRead).length;

    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoadingNotifications.value = false;
    }
  }
  
  // <<< 1. แก้ไข: ฟังก์ชัน Mark as Read (ลบ .execute() และปรับการตรวจสอบ Error) >>>
  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0 || _loginController.userId.value.isEmpty) return;

    try {
      // 1. Update DB to mark all notifications as read
      // *** FIX: ใช้ .select() แทน .execute() เพื่อให้ Supabase Flutter SDK V2+ ทำงานได้ ***
      final response = await supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', _loginController.userId.value)
          .eq('is_read', false)
          .select(); 

      // 2. ตรวจสอบ Error (ถ้า response เป็น PostgrestError จะถูก throw ใน try block นี้)
      // ถ้าโค้ดมาถึงตรงนี้ แสดงว่า Update สำเร็จ (หรือมี 0 แถวที่อัปเดต)

      // 3. Re-fetch to ensure local state consistency
      await fetchNotifications(); 

    } on PostgrestException catch (e) {
      print("Error marking notifications as read: $e");
      // แสดง error ให้ User ทราบ (กรณี RLS บล็อก)
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถอัปเดตสถานะแจ้งเตือนได้ (ขาดสิทธิ์ RLS?): ${e.message}');
    } catch (e) {
      print("Unknown Error marking notifications as read: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถอัปเดตสถานะแจ้งเตือนได้: ${e.toString()}');
    }
  }

  void switchView(int index) {
    final newView = (index == 0) ? MyShopView.shops : MyShopView.requests;
    if (currentView.value != newView) {
      currentView.value = newView;
      if (newView == MyShopView.requests) {
        fetchMyRequests(); 
      }
    }
  }

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

      final editData = await supabase
          .from('restaurant_edits')
          .select("*, res_name_from_data:proposed_data->>res_name") 
          .eq('user_id', currentUserId) 
          .order('created_at', ascending: false);

      final complaintData = await supabase
          .from('complaints')
          .select('''
            *, 
            restaurants ( res_name ), 
            comments ( content )
          ''')
          .eq('reporter_id', currentUserId) 
          .order('created_at', ascending: false);

      final List<MyRequestStatus> requests = editData
          .map((map) => MyRequestStatus.fromRestaurantEdit(map))
          .toList();
      
      final List<MyRequestStatus> complaints = complaintData
          .map((map) => MyRequestStatus.fromComplaint(map))
          .toList();

      final combinedList = [...requests, ...complaints];

      combinedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      myRequestList.assignAll(combinedList);

    } catch (e) {
      print("Error fetching my requests: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถดึงข้อมูลคำร้องได้: ${e.toString()}');
    } finally {
      isLoadingRequests.value = false;
    }
  }

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