// lib/app/ui/pages/my_shop_page/my_shop_page.dart

import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarA.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../../../routes/app_routes.dart'; 
import '../restaurant_detail_page/widgets/scrollctrl.dart';

// <<< 1. Import Widgets ใหม่ ---
import 'widgets/my_shop_show_card.dart';
import 'widgets/my_shop_toggle_bar.dart';
import 'widgets/my_shop_request_list.dart';
// <<< สิ้นสุดการ Import ---

class MyShopPage extends GetView<MyShopController> {
  MyShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollpageController scrollpageController =
        Get.find<ScrollpageController>(tag: 'myshop_scroll');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.pink[200],
        appBar: AppbarA(tag: 'myshop filter ctrl'),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.pink[200]!],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SingleChildScrollView(
                          controller: scrollpageController.scrollController,
                          // <<< 2. แก้ไข Padding ---
                          padding: const EdgeInsets.all(0.0), // <<< ใช้ Padding 0
                          child: Column( // <<< 3. เพิ่ม Column ครอบ
                            children: [
                              // --- Widget 1: Toggle Bar ---
                              const MyShopToggleBar(), // <<< 4. เพิ่มปุ่มสลับหน้า
                              
                              // --- Widget 2: Content (สลับตาม View) ---
                              Obx(() { // <<< 5. เพิ่ม Obx
                                // แยก Padding ลงไปใน child แต่ละอัน
                                if (controller.currentView.value == MyShopView.shops) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Showshopcard(), // <<< หน้าเดิม
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    child: MyShopRequestList(), // <<< หน้าใหม่
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BtScrollTop(tag: 'myshop_scroll'),
            ],
          ),
        ),
        // (Floating Action Button ... เหมือนเดิม)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.ADDRESTAURANT); 
          },
          backgroundColor: Colors.pink[400],
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}