// lib/app/ui/global_widgets/slidectrl.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // <<<--- 1. Import สำหรับ Randomizer

import '../../model/bannerslide.dart';
import '../../routes/app_routes.dart';

import '../../model/restaurant.dart';
import 'filter_ctrl.dart';

class SlideController extends GetxController {
  final RxList<BannerItem> originalBannerItems = <BannerItem>[].obs;
  late final RxList<BannerItem> displayBannerItems;
  final RxInt currentPage = 0.obs;
  late PageController pageController;
  Timer? _timer;
  static const int _initialPageIndex = 1;

  final FilterController _filterController = Get.find<FilterController>(); // <<<--- 2. Find FilterController
  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    
    // ตั้งค่าเริ่มต้นสำหรับ displayBannerItems (ต้องทำก่อน pageController)
    displayBannerItems = <BannerItem>[].obs;
    
    // ตั้งค่า pageController
    pageController = PageController(initialPage: _initialPageIndex);
    currentPage.value = _initialPageIndex;

    // --- 3. Listener: กรองและสุ่ม Banner เมื่อร้านอาหารโหลดเสร็จ ---
    // รัน _updateBanners เมื่อ allRestaurantsObservable มีการเปลี่ยนแปลง
    ever(_filterController.allRestaurantsObservable, (_) => _updateBanners());
  }

  // --- 4. ฟังก์ชันสำหรับกรอง, สุ่ม และอัปเดต Banner ---
  void _updateBanners() {
    // 4.1. กรอง: เลือกร้านที่มี Rating 4.0 ขึ้นไป
    final List<Restaurant> highRatedRestaurants = _filterController
        .allRestaurantsObservable
        .where((r) => r.rating >= 4.0 && r.imageUrl != null && r.imageUrl!.isNotEmpty)
        .toList();

    // 4.2. สุ่ม: สุ่มลำดับร้านค้าที่ผ่านการกรอง
    highRatedRestaurants.shuffle(_random); 

    // 4.3. จำกัด: นำมาใช้สูงสุดแค่ 5 ร้าน (ใช้ .take(5))
    final List<Restaurant> limitedRestaurants = highRatedRestaurants.take(5).toList();

    // 4.4. Mapping: สร้าง List ของ BannerItem
    final List<BannerItem> newOriginalItems = limitedRestaurants
        .map((r) => BannerItem(
            imagePath: r.imageUrl!, 
            restaurantId: r.id))
        .toList();

    // 4.5. อัปเดต State
    originalBannerItems.assignAll(newOriginalItems);
    _rebuildDisplayList();
    _startAutoScroll(); // เริ่ม Auto Scroll หลังโหลด
  }

  // --- 5. ฟังก์ชันช่วยในการสร้าง List สำหรับ Infinite Scroll ---
  void _rebuildDisplayList() {
    if (originalBannerItems.length < 2) {
      displayBannerItems.assignAll(originalBannerItems);
    } else {
      // สร้าง List สำหรับ Infinite Scroll: [Last, 1, 2, ..., N, First]
      displayBannerItems.assignAll([
        originalBannerItems.last,
        ...originalBannerItems,
        originalBannerItems.first,
      ]);
    }
    // รีเซ็ต PageController ไปยังตำแหน่งเริ่มต้น
    if (pageController.hasClients) {
        pageController.jumpToPage(_initialPageIndex);
    }
    currentPage.value = _initialPageIndex;
  }
  
  @override
  void onReady() {
    super.onReady();
    if (displayBannerItems.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (displayBannerItems.length < 2) {
      return; // ไม่ต้อง scroll ถ้ามีน้อยกว่า 2
    }
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      
      // --- [แก้ไข] ---
      // ตรวจสอบก่อนว่า PageController ยังเชื่อมต่ออยู่หรือไม่
      if (!pageController.hasClients) {
        _timer?.cancel(); // ถ้าไม่เชื่อมต่อแล้ว ให้หยุด Timer
        return;
      }
      // --- [สิ้นสุดการแก้ไข] ---

      int targetPage = currentPage.value + 1;

      if (pageController.hasClients) {
        // หากกำลังจะเลื่อนไปยังตำแหน่งซ้ำ (อันสุดท้าย)
        if (targetPage == displayBannerItems.length - 1) {
             pageController
                .animateToPage(
                  targetPage,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                )
                .then((_) {
                  // --- [แก้ไข] ตรวจสอบอีกครั้งก่อน Jump ---
                  if (pageController.hasClients) {
                    // กระโดดกลับไปหน้าแรกจริงๆ (index 1) โดยไม่มี animation
                    pageController.jumpToPage(_initialPageIndex);
                    currentPage.value = _initialPageIndex;
                  }
                  // --- [สิ้นสุดการแก้ไข] ---
                });
        }
        // เลื่อนไปยังหน้าถัดไปตามปกติ
        else {
             pageController
                .animateToPage(
                  targetPage,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                )
                .then((_) {
                  if (pageController.hasClients && pageController.page != null) {
                    currentPage.value = pageController.page!.round();
                  }
                });
        }
      }
    });
  }

  void onPageChanged(int page) {
    // --- [แก้ไข] ตรวจสอบก่อนว่า PageController ยังเชื่อมต่ออยู่หรือไม่ ---
    if (!pageController.hasClients) return;
    // --- [สิ้นสุดการแก้ไข] ---

    currentPage.value = page;
    
    // --- จัดการ Jump สำหรับ Infinite Scroll ---
    if (page == 0 && displayBannerItems.length > 1) {
      // ถ้าเลื่อนไปหน้าซ้ำแรก (index 0) ให้กระโดดไปหน้าสุดท้ายจริงๆ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(originalBannerItems.length);
          currentPage.value = originalBannerItems.length;
        }
      });
    } else if (page == displayBannerItems.length - 1 && displayBannerItems.length > 1) {
      // ถ้าเลื่อนไปหน้าซ้ำสุดท้าย (index N+1) ให้กระโดดไปหน้าแรกจริงๆ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(_initialPageIndex);
          currentPage.value = _initialPageIndex;
        }
      });
    }
    _startAutoScroll(); // รีเซ็ต Timer เมื่อผู้ใช้เลื่อนเอง
  }

  void navigateToRestaurantDetail(String restaurantId) {
    Get.toNamed(
      AppRoutes.RESTAURANTDETAIL + '/$restaurantId',
      parameters: {'restaurantId': restaurantId},
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}