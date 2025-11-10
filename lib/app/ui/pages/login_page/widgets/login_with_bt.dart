import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login_controller.dart';

class LoginWithBt extends StatelessWidget {
  LoginWithBt({super.key});
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Or Login with",
                style: GoogleFonts.urbanist(
                  color:  Colors. limeAccent[400],
                  fontSize: 14,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
       
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.facebook, color: Colors.blue),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size(80, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                debugPrint('=====> Facebook login tapped');
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.g_mobiledata, color: Colors.red),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size(80, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                debugPrint('=====> Google login tapped');
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.apple, color: Colors.black),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size(80, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                debugPrint('=====> Apple login tapped');
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
