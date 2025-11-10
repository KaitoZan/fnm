import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login_page/login_controller.dart';



class ShowProfileDetail extends StatelessWidget {
  const ShowProfileDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    return Column(
       mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => _buildTextFieldWithLabel(
            'ชื่อเล่น',
            loginController.userName.value,
          ),
        ),

        Obx(
          () => _buildTextFieldWithLabel(
            'เบอร์โทรศัพท์',
            loginController.userPhoneNumber.value,
          ),
        ),
        Obx(
          () => _buildTextFieldWithLabel(
            'อีเมล',
            loginController.userEmail.value,
          ),
        ),
        Obx(
          () => _buildTextFieldWithLabel(
            'ที่อยู่',
            loginController.userlocations.value,
          ),
        ),
      ],
    );
  }
}

Widget _buildTextFieldWithLabel(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Column(
     
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 3),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
          readOnly: true,
        ),
      ],
    ),
  );
}
