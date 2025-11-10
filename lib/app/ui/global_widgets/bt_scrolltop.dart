import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/restaurant_detail_page/widgets/scrollctrl.dart';
import 'scrolltotop_bt.dart';

class BtScrollTop extends StatelessWidget {
  const BtScrollTop({super.key, required this.tag});
  final String tag;
  @override
  Widget build(BuildContext context) {
    final ScrollpageController scrollpageController =
        Get.find<ScrollpageController>(tag: tag);
    return Obx(
      () => scrollpageController.showScrollToTopButton.value
          ? Positioned(
              right: 20.0,
              // --- [แก้ไข] ---
              // เปลี่ยนจาก 16.0 เป็น 90.0
              // เพื่อย้ายตำแหน่งปุ่มให้สูงขึ้น หลบปุ่ม Save/Add ที่อยู่ด้านล่าง
              bottom: MediaQuery.of(context).padding.bottom + 90.0,
              // --- [สิ้นสุดการแก้ไข] ---
              child: ScrollToTopButton(
                onPressed: scrollpageController.scrollToTop,
              ),
            )
          : Container(),
    );
  }
}