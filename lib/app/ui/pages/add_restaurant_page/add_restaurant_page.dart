// lib.zip/app/ui/pages/add_restaurant_page/add_restaurant_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart';
import 'add_restaurant_controller.dart'; 
import 'widgets/add_form_edit.dart';

// <<<--- [TASK 24.3 - เพิ่ม] Import
import '../edit_restaurant_detail_page/widgets/eddt_head_text.dart'; 
// <<<--- [สิ้นสุดการเพิ่ม]


class AddRestaurantPage extends GetView<AddRestaurantController> {
  const AddRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller หลัก: controller (จาก GetView)
    
    // Scroll Controller: ใช้ tag เฉพาะ
    final String scrollTag = 'add_details_scroll'; 
    final ScrollpageController scrollpageController = Get.find<ScrollpageController>(tag: scrollTag);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // --- AppBar ---
        appBar: AppBar(
          backgroundColor: Colors.pink[200],
          leading: const Back3Bt(),
          
          // <<<--- [TASK 24.3 - เริ่มแก้ไข] ---
          // (ลบ title และ centerTitle ออก)
          // title: const Text('เพิ่มร้านค้าใหม่'), 
          // centerTitle: true,
          // <<<--- [TASK 24.3 - สิ้นสุดการแก้ไข] ---
          
          toolbarHeight: kToolbarHeight + 16,
          automaticallyImplyLeading: false,
          flexibleSpace: Container( // Gradient Background
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
        // --- Body ---
        body: Stack( 
          children: [
            // --- Background Gradient ---
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
                  // (Container(height: 50) ถูกลบไปแล้ว)
                  
                  // --- ส่วนล่าง (เนื้อหาสีขาวขอบมน) ---
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                          child: SingleChildScrollView( 
                            controller: scrollpageController.scrollController,
                            padding: const EdgeInsets.only(top: 16.0, bottom: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                
                                // <<<--- [TASK 24.3 - เริ่มแก้ไข] ---
                                // (เพิ่ม Title ที่นี่)
                                const EdDtHeadText(title: "เพิ่มร้านค้าใหม่"),
                                const SizedBox(height: 20), // (เพิ่มระยะห่าง)
                                // <<<--- [TASK 24.3 - สิ้นสุดการแก้ไข] ---
                                
                                const AddFormEdit(), 
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),

            // --- ปุ่ม Scroll To Top ---
            BtScrollTop(tag: scrollTag), 

            // --- ปุ่ม Save (Adapted for Add) ---
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.saveNewRestaurant(), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'บันทึกร้านค้าใหม่',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}