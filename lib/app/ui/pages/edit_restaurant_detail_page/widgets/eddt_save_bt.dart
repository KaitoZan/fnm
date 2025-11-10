import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 1. Import controller ที่ถูกต้อง
import '../edit_restaurant_detail_controller.dart';

class EddtSaveBt extends StatelessWidget {
  final String restaurantId;
  const EddtSaveBt({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    // 2. แก้ไขชื่อ Controller ให้ถูกต้อง
    final RestaurantEditDetailController editRestaurantController =
        Get.find<RestaurantEditDetailController>(tag: restaurantId);
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: editRestaurantController.isLoading.value
              ? null
              : () => editRestaurantController.saveChanges(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[400],
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: editRestaurantController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'บันทึกการเปลี่ยนแปลง',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
