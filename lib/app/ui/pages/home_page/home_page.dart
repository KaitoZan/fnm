import 'package:flutter/material.dart';


import 'package:food_near_me_app/app/ui/pages/home_page/home_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarA.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../../global_widgets/search_bar_filter.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart';
import 'widgets/home_location_FilterBar.dart';
import 'widgets/home_show_card.dart';
import 'widgets/home_slide_image.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final ScrollpageController scrollpageController =
      Get.find<ScrollpageController>(tag: 'home_scroll');

  @override
  Widget build(BuildContext context) {
    // final FilterController filterController = Get.find<FilterController>();
    // final FilterController filterController = Get.find<FilterController>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.pink[200],
        appBar: AppbarA(tag: 'home filter ctrl'),
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
                          // <<<--- [TASK 12.1 - เพิ่ม]
                          physics: const AlwaysScrollableScrollPhysics(), // <<< ทำให้เลื่อนได้เสมอ
                          // <<<--- [สิ้นสุดการเพิ่ม]
                          controller: scrollpageController.scrollController,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SearchBarFilter(tag: 'home'),
                              const HomeLocationFilterbar(),
                              const SizedBox(height: 8),
                              HomeSlideImage(),
                              const SizedBox(height: 8),
                              ShowCardHome(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BtScrollTop(tag: 'home_scroll'),
              // (โค้ด Obx ของ BtScrollTop ... ถูกย้ายไปใน BtScrollTop.dart แล้ว)
            ],
          ),
        ),
      ),
    );
  }
}