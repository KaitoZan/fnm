// lib.zip/app/ui/pages/my_shop_page/widgets/my_shop_toggle_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../my_shop_controller.dart';
// Note: ไม่ต้อง Import notification_bell_popup.dart ที่นี่แล้ว

class MyShopToggleBar extends StatelessWidget {
  const MyShopToggleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MyShopController controller = Get.find<MyShopController>();
    
    return Container(
      // width: double.infinity, // ลบทิ้งแล้ว
      padding: const EdgeInsets.symmetric(vertical: 12.0), 
      child: Center( 
        child: Obx(() => ToggleButtons(
          isSelected: [
            controller.currentView.value == MyShopView.shops,
            controller.currentView.value == MyShopView.requests,
          ],
          onPressed: (index) {
            controller.switchView(index);
          },
          borderRadius: BorderRadius.circular(20.0),
          selectedColor: Colors.white,
          color: Colors.pink[700],
          fillColor: Colors.pink[300],
          selectedBorderColor: Colors.pink[400],
          borderColor: Colors.pink[200],
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0), // <<< FIX: ลด Padding ลงเหลือ 12.0
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, size: 20),
                  SizedBox(width: 8),
                  Text('ร้านค้าของฉัน'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0), // <<< FIX: ลด Padding ลงเหลือ 12.0
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('สถานะคำร้อง'),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}