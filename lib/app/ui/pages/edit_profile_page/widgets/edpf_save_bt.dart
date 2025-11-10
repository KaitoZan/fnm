import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_profile_controller.dart';



class EdpfSaveBt extends StatelessWidget {
  const EdpfSaveBt({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController editController =
        Get.find<EditProfileController>();

    return Column(
      children: [
        Obx(
          () => ElevatedButton(
            onPressed: editController.isLoading.value
                ? null
                : () => editController.saveProfile(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Colors.pink[400],
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
        
            child: editController.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
