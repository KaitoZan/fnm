// lib.zip/app/ui/pages/my_shop_page/widgets/notification_bell_popup.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../my_shop_controller.dart';
// import '../../../model/notification_model.dart';

class NotificationBellPopup extends StatelessWidget {
  const NotificationBellPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final MyShopController controller = Get.find<MyShopController>();

    return Obx(() {
      final unreadCount = controller.unreadCount.value;
      return GestureDetector(
        onTap: () {
          controller.fetchNotifications();
          _showNotificationBottomSheet(context, controller); // <<< CHANGE 1: ใช้ Bottom Sheet
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.pink.shade200),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.pink.shade700,
                size: 24,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // <<< CHANGE 2: ฟังก์ชันใหม่สำหรับ Bottom Sheet >>>
  void _showNotificationBottomSheet(BuildContext context, MyShopController controller) {
    Get.bottomSheet(
      // (1) Container หลักสำหรับ Bottom Sheet
      Container(
        // จำกัดความสูงไม่เกิน 75% ของหน้าจอ
        constraints: BoxConstraints(maxHeight: Get.height * 0.75), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min, // ทำให้ Column หดตัวตามเนื้อหา
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Header Title พร้อมปุ่มปิด ---
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 8), // ลด right padding เพราะมีปุ่มปิด
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "การแจ้งเตือนของคุณ",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            
            // --- Mark as Read Button (ถ้ามี) ---
            Obx(() {
              if (controller.unreadCount.value == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.markAllAsRead,
                    child: const Text("ทำเครื่องหมายว่าอ่านแล้วทั้งหมด"),
                  ),
                ),
              );
            }),

            // --- Notification List ---
            Obx(() {
              if (controller.isLoadingNotifications.value) {
                return const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.notifications.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Center(child: Text("ไม่มีการแจ้งเตือน")),
                );
              }

              // (2) ใช้ Flexible/Expanded เพื่อให้ ListView ใช้พื้นที่ที่เหลือและ scroll ได้
              return Flexible(
                child: ListView.builder(
                  shrinkWrap: true, // ใช้ shrinkWrap เพราะอยู่ภายใน Column ที่มี mainAxisSize: min
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.grey.shade100
                            : Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: notification.isRead ? Colors.grey.shade700 : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              fontSize: 13,
                              color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              notification.formattedDate,
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
            // --- Footer (Area Safe Zone) ---
            const SizedBox(height: 16),
            SafeArea(child: const SizedBox.shrink()),
          ],
        ),
      ),
      isScrollControlled: true, // ทำให้ BottomSheet สามารถกำหนดความสูงได้
    );
  }
}