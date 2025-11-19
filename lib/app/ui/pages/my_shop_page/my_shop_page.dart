// lib.zip/app/ui/pages/my_shop_page/my_shop_page.dart

import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarA.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../../../routes/app_routes.dart'; 
import '../restaurant_detail_page/widgets/scrollctrl.dart';

import 'widgets/my_shop_show_card.dart';
import 'widgets/my_shop_toggle_bar.dart';
import 'widgets/my_shop_request_list.dart';
import 'widgets/notification_bell_popup.dart'; // <<< Import

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
                          padding: const EdgeInsets.all(0.0), 
                          child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // <<< Row จัด ToggleBar (กลาง) และ Bell (ขวา) >>>
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 2.1 Placeholder (เพื่อให้ ToggleBar อยู่ตรงกลาง)
                                    const SizedBox(width: 40), 

                                    // 2.2 ToggleBar (ใช้ Expanded เพื่อให้ ToggleBar กว้างพอ)
                                    const Expanded(
                                      child: MyShopToggleBar()
                                    ), 

                                    // 2.3 Notification Bell (อยู่ขวา)
                                    const NotificationBellPopup(),
                                  ],
                                ),
                              ),
                              // <<< สิ้นสุด Row >>>
                              
                              // --- Content ---
                              Obx(() { 
                                if (controller.currentView.value == MyShopView.shops) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0), 
                                    child: Showshopcard(), 
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0), 
                                    child: MyShopRequestList(), 
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