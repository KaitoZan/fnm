import 'package:food_near_me_app/app/ui/pages/favourite_page/favourite_page.dart';
import 'package:food_near_me_app/app/ui/pages/home_page/home_page.dart';
import 'package:food_near_me_app/app/ui/pages/login_page/login_page.dart';
import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../routes/app_routes.dart';
import '../login_page/login_controller.dart';

class NavbarController extends GetxController {
  late PersistentTabController tabController;
  final LoginController _loginController = Get.find<LoginController>();
  int _previousIndex = 1; // หน้าแรกคือ Home (index 1)

  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: _previousIndex); // เริ่มที่ Home
    // เพิ่ม listener เพื่อตรวจสอบการเปลี่ยน tab
    tabController.addListener(_handleTabChange);
    // เพิ่ม listener เพื่อตรวจสอบการเปลี่ยนแปลงสถานะ login
    ever(_loginController.isLoggedIn, _handleLoginStatusChange);
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {
    // ตรวจสอบเมื่อ *กำลังจะ* ไปยัง tab ที่ต้อง login
    if ((tabController.index == 0 || tabController.index == 2) &&
        !_loginController.isLoggedIn.value) {
      // แสดง dialog และ *ป้องกัน* การเปลี่ยน tab โดยการ jump กลับไป tab เดิม
      WidgetsBinding.instance.addPostFrameCallback((_) { // ใช้ addPostFrameCallback เพื่อให้ dialog แสดงหลัง build เสร็จ
          _showLoginDialog();
          tabController.jumpToTab(_previousIndex); // กลับไป tab ก่อนหน้า
      });

    } else {
      // ถ้า tab เปลี่ยนได้ตามปกติ ให้อัปเดต previousIndex
       if (_previousIndex != tabController.index) {
           _previousIndex = tabController.index;
       }
    }
  }

    // ฟังก์ชันนี้จะถูกเรียกเมื่อสถานะ login เปลี่ยน
   void _handleLoginStatusChange(bool isLoggedIn) {
    // ถ้า logout ขณะอยู่ที่หน้า Favorite หรือ MyShop ให้เด้งกลับไปหน้า Home
    if (!isLoggedIn && (tabController.index == 0 || tabController.index == 2)) {
      goToHomeTab();
    }
  }


  void _showLoginDialog() {
     if (Get.isDialogOpen ?? false) return; // ป้องกัน dialog ซ้อน

    Get.defaultDialog(
      title: 'แจ้งเตือน',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("ไปยังหน้าเข้าสู่ระบบ ?"),
          const SizedBox(height: 8 * 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // ปิด dialog
                      // Get.offAll(() => LoginPage()); // ไปหน้า Login
                      Get.offAllNamed(AppRoutes.LOGIN);  

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.green),
                    ),
                    child: const Text(
                      "ตกลง",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // ปิด dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      "ยกเลิก",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  // สร้าง list ของ tabs ที่นี่
  List<PersistentTabConfig> get tabs {
    return [
      PersistentTabConfig(
        screen: FavouritePage(),
        item: ItemConfig(
          icon: Icon(Icons.star, color: Colors.amber),
          title: "รายการโปรด",
          activeForegroundColor: Colors.white,
          inactiveForegroundColor: Colors.white,
        ),
      ),
      PersistentTabConfig(
        screen: HomePage(),
        item: ItemConfig(
          icon: Icon(Icons.home, color: Colors.teal.shade200),
          title: "หน้าแรก",
          activeForegroundColor: Colors.white,
          inactiveForegroundColor: Colors.white,
        ),
      ),
      PersistentTabConfig(
        screen: MyShopPage(),
        item: ItemConfig(
          icon: Icon(Icons.backup_table, color: Colors.limeAccent),
          title: "ร้านค้าของฉัน",
          activeForegroundColor: Colors.white,
          inactiveForegroundColor: Colors.white,
        ),
      ),
    ];
  }

  // ฟังก์ชันสำหรับไปหน้า Home
  void goToHomeTab() {
    tabController.jumpToTab(1); // Index 1 คือ Home
  }
}
