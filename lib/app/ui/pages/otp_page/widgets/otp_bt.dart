import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../otp_controller.dart';

class OtpBt extends StatelessWidget {
   OtpBt({super.key});
  final OtpController controller = Get.find<OtpController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: controller.verifyOtp,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), 
              backgroundColor: Colors.pink.withValues(alpha: 8 * 0.03),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Verify',
              style: GoogleFonts.charmonman(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}