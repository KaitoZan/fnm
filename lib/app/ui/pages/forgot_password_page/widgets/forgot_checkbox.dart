import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- แก้ไข import ---
import '../forgot_password_controller.dart'; // import controller หลัก

// --- เปลี่ยนเป็น StatelessWidget และรับ Controller ---
class CheckboxWidget extends StatelessWidget {
  CheckboxWidget({super.key});

  // --- ใช้ Get.find() เพื่อหา CheckboxController ที่ Binding สร้างไว้ ---
  final CheckboxController checkboxController = Get.find<CheckboxController>();

  @override
  Widget build(BuildContext context) {
    // --- ไม่ต้องใช้ GetView เพราะเรา Get.find() แล้ว ---
    return Container( // อาจจะไม่จำเป็นต้องมี Container ครอบ
      child: Obx(
        () => Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                // --- เรียกใช้ controller ที่ find มา ---
                value: checkboxController.isChecked.value,
                onChanged: checkboxController.toggleCheckbox,
                activeColor: Colors.pink.shade300,
                checkColor: Colors.white,
              ),
            ),
             // Optional: เพิ่ม Text ข้างๆ Checkbox
             const Text(
              "ฉันไม่ใช่โปรแกรมอัตโนมัติ",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
