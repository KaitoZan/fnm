// lib/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart'; 
import 'edit_restaurant_detail_controller.dart';
import 'widgets/eddt_form_edit.dart';
import 'widgets/eddt_head_text.dart';
import 'widgets/eddt_save_bt.dart';


class EditRestaurantDetailsPage extends GetView<RestaurantEditDetailController> {
  final String restaurantId;
  const EditRestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  String? get tag => restaurantId; 

  @override
  Widget build(BuildContext context) {
    // (controller ถูกหาโดย GetView + tag)
    
    final String scrollTag = 'edit_details_scroll_$restaurantId'; 
    final ScrollpageController scrollpageController = Get.find<ScrollpageController>(tag: scrollTag);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[200],
          leading: const Back3Bt(), 
          toolbarHeight: kToolbarHeight + 16, 
          automaticallyImplyLeading: false,
          flexibleSpace: Container( 
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[200]!, Colors.blue[200]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                transform: const GradientRotation(3.0),
              ),
            ),
          ),
        ),
        body: Stack( 
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink[200]!, Colors.blue[200]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  transform: const GradientRotation(3.0),
                ),
              ),
              child: Column( 
                children: [
                  Container( height: 50 ),
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
                      child: Obx(() {
                        if (controller.restaurantToEdit.value == null) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                          child: SingleChildScrollView( 
                            controller: scrollpageController.scrollController, 
                            padding: const EdgeInsets.only(top: 16.0, bottom: 120), 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                const EdDtHeadText(), 
                                const SizedBox(height: 20),
                                
                                // --- [แก้ไข] (แก้บั๊ก Get.find [image_148c23.png]) ---
                                // ส่ง 'controller' (ที่ได้จาก GetView) เข้าไป
                                EddtFormEdit(
                                  restaurantId: restaurantId,
                                  controller: controller, // <<<--- ส่ง Controller
                                ), 
                                // --- [สิ้นสุดการแก้ไข] ---
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            BtScrollTop(tag: scrollTag), 
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: EddtSaveBt(restaurantId: restaurantId), 
            ),
          ],
        ),
      ),
    );
  }
}