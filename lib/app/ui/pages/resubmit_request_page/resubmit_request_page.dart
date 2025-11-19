// lib.zip/app/ui/pages/my_shop_page/widgets/resubmit_request_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 1. Import Model (เพื่อใช้ Enum)

import '../../../model/my_request_status.dart';
import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/bt_scrolltop.dart';

import '../edit_restaurant_detail_page/widgets/eddt_form_edit.dart';
// (ลบ EdDtHeadText เดิมออก เพราะเราจะใช้ Logic)
// import '../edit_restaurant_detail_page/widgets/eddt_head_text.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart';
import 'resubmit_request_controller.dart';

// <<<--- [TASK 24.4 - เพิ่ม] Import
import '../edit_restaurant_detail_page/widgets/eddt_head_text.dart'; 
// <<<--- [สิ้นสุดการเพิ่ม]

class ResubmitRequestPage extends GetView<ResubmitRequestController> {
  final String requestEditId;
  const ResubmitRequestPage({super.key, required this.requestEditId});

  @override
  String? get tag => requestEditId; 

  @override
  Widget build(BuildContext context) {
    // (controller ถูกหาโดย GetView + tag)
    
    final String scrollTag = 'resubmit_scroll_$requestEditId'; 
    final ScrollpageController scrollpageController = Get.find<ScrollpageController>(tag: scrollTag);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // (Title ถูกลบไปแล้ว ดีแล้ว)
          
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
                  // (Container(height: 50) ถูกลบไปแล้ว)

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
                        if (controller.isPageLoading.value) {
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
                                
                                // <<<--- [TASK 25 - เริ่มแก้ไข] ---
                                // (ย้าย Logic การแสดง Title มาไว้ที่นี่)
                                Obx(() {
                                    String titleText = 'รายละเอียดคำร้อง';
                                    if (controller.isPageLoading.value) {
                                      titleText = 'กำลังโหลด...';
                                    } else if (controller.originalStatus.value == RequestStatus.rejected) {
                                      // (แก้หน้านี้ด้วย)
                                      titleText = 'แก้ไขคำร้อง\n(ที่ถูกปฏิเสธ)';
                                    } else if (controller.originalStatus.value == RequestStatus.pending) {
                                      // (แก้หน้านี้)
                                      titleText = 'รายละเอียดคำร้อง\n(รอตรวจสอบ)';
                                    } else {
                                      // (แก้หน้านี้ด้วย)
                                      titleText = 'รายละเอียดคำร้อง\n(อนุมัติแล้ว)';
                                    }
                                    return EdDtHeadText(title: titleText);
                                }),
                                // <<<--- [TASK 25 - สิ้นสุดการแก้ไข] ---
                                
                                const SizedBox(height: 20),
                                
                                // (Obx rejectionReason ... เหมือนเดิม)
                                Obx(() {
                                  if (controller.rejectionReason.value.isNotEmpty) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12.0),
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: Colors.red.shade200)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'เหตุผลที่ถูกปฏิเสธ:', 
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold, 
                                              color: Colors.red,
                                              fontSize: 16
                                            )
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            controller.rejectionReason.value,
                                            style: TextStyle(color: Colors.red[800], fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                                
                                // (Form)
                                EddtFormEdit(
                                  restaurantId: requestEditId,
                                  controller: controller, 
                                ), 
                                const SizedBox(height: 30),
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
            Obx(() {
                if (controller.originalStatus.value != RequestStatus.rejected) {
                  return const SizedBox.shrink();
                }
                
                return Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Obx( 
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.resubmitRequest(), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700], 
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'ส่งคำร้องอีกครั้ง', 
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
}