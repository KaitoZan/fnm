import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forgot_password_controller.dart';
class ForgotFormEdit extends StatelessWidget {
   ForgotFormEdit({super.key});
  final ForgotPasswordController controller = Get.find<ForgotPasswordController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.1),
          child: TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: GoogleFonts.charmonman(
                color: Colors.white.withValues(alpha: 8 * 0.07),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 8 * 0.03),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
