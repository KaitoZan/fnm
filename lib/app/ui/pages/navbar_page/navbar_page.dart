// lib/app/ui/pages/navbar_page/navbar_page.dart
import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_controller.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// --- 1. เปลี่ยนกลับเป็น StatelessWidget และใช้ GetView<NavbarController> ---
class NavbarPage extends GetView<NavbarController> {
  // ใช้ const constructor
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 2. Controller จะถูก inject โดย GetView โดยอัตโนมัติ ---
    // ไม่ต้อง Get.find() เอง

    return PersistentTabView(
      controller: controller.tabController, // <<<--- ใช้ controller จาก GetView
      tabs: controller.tabs, // <<<--- ใช้ controller จาก GetView
      navBarBuilder: (navBarConfig) => Style6BottomNavBar(
        navBarConfig: navBarConfig,
        // --- ปรับปรุง UI เล็กน้อย ---
        navBarDecoration: NavBarDecoration(
          // color: Colors.pink[200], // ใช้ Gradient แทน
          borderRadius: const BorderRadius.only( // <<<--- เพิ่มขอบมน
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
          gradient: LinearGradient( // <<<--- ใช้ Gradient
            colors: [Colors.pink[200]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [ // <<<--- เพิ่มเงา
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        // itemPadding: EdgeInsets.symmetric(horizontal: 10), // ปรับระยะห่าง Item (ถ้าต้องการ)
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // ไม่มี FAB
      screenTransitionAnimation: const ScreenTransitionAnimation( // <<<--- เพิ่ม const
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      stateManagement: true, // <<<--- ให้ PersistentTabView จัดการ State ของแต่ละหน้า
      backgroundColor: Colors.white, // <<<--- สีพื้นหลังของเนื้อหาข้างบน TabBar
      // handleAndroidBackButtonPress: true, // จัดการปุ่ม Back ของ Android (ถ้าต้องการ)
      
      // <<<--- [TASK 11.1 - แก้ไข] ---
      // เปิดใช้งาน (Uncomment) บรรทัดนี้
      resizeToAvoidBottomInset: true, // ปรับขนาดเมื่อ Keyboard แสดง (สำคัญ!)
      // <<<--- [สิ้นสุดการแก้ไข] ---
      
      // hideNavigationBarWhenKeyboardShows: true, // ซ่อน Navbar เมื่อ Keyboard แสดง (ถ้าต้องการ)
    );
  }
}