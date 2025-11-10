import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../otp_controller.dart';

class OtpFormEdit extends StatelessWidget {
   OtpFormEdit({super.key});
  final OtpController controller = Get.find<OtpController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8 * 1,
              horizontal: 8 * 0.68,
            ),
            child: TextField(
              controller: controller.otpcontroller[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              onChanged: (value) {
                if (value.length == 1 && index < 4) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 8 * 0.03),
              ),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
