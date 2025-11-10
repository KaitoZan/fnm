import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../edit_profile_controller.dart';

class EdpfFormEdit extends StatelessWidget {
  const EdpfFormEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController editController =
        Get.find<EditProfileController>();
    return Column(
      children: [
        _buildTextFieldWithLabel(
          'ชื่อเล่น',
          editController.nicknameController,
          false,
        ),
        _buildTextFieldWithLabel(
          'เบอร์โทรศัพท์',
          editController.phoneController,
          false,
        ),
        _buildTextFieldWithLabel(
          'อีเมล',
          editController.emailController,
          false,
        ),
        _buildTextFieldWithLabel(
          'ที่อยู่',
          editController.locationController,
          true,
        ),
      ],
    );
  }
}

Widget _buildTextFieldWithLabel(
  String label,
  TextEditingController controller,
  bool isObscure,
) {
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
        const SizedBox(height: 3),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'กรอก $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
        ),
      ],
    ),
  );
}
