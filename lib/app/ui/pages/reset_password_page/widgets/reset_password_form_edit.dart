
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reset_password_controller.dart';


class ResetPasswordFormEdit extends StatelessWidget {
   ResetPasswordFormEdit({super.key});
  final ResetPasswordController controller = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
 Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 * 0.1),
          child: Obx(
            () => TextField(
              controller: controller.passwordController,
              obscureText: controller.obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 8 * 0.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Password',
                hintStyle: GoogleFonts.charmonman(
                  color: Colors.white.withValues(alpha: 8 * 0.07),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
           
                    controller.obscureText = !controller.obscureText;
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 * 0.1),
          child: Obx(
            () => TextField(
              controller: controller.confirmPasswordController,
              obscureText: controller.obscureText2,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 8 * 0.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Confirm Password',
                hintStyle: GoogleFonts.charmonman(
                  color: Colors.white.withValues(alpha: 8 * 0.07),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureText2
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    controller.obscureText2 = !controller.obscureText2;
                  },
                ),
              ),
            ),
          ),
        ),
                SizedBox(height: 8 * 2),
      ],
    );
  }
}