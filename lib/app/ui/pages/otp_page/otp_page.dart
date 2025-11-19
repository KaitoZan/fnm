import 'package:flutter/material.dart';



import 'package:food_near_me_app/app/ui/pages/otp_page/otp_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/backgoundlogin.dart';
import '../../global_widgets/blurcontainer.dart';
import '../../global_widgets/iconperson.dart';
import 'widgets/otp_bt.dart';
import 'widgets/otp_form_edit.dart';
import 'widgets/otp_head_text.dart';
import 'widgets/otp_logo.dart';

class OtpPage extends GetView<OtpController> {
  OtpPage({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Positioned.fill(child: Backgoundlogin()),

          Scaffold(
            backgroundColor: Colors.transparent,

            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8 * 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    SizedBox(height: 20),

                    Blurcontainer(
                      width: MediaQuery.of(context).size.width * 0.88,
                      // (height ถูกลบไปแล้ว ดีแล้ว)
                      // height: MediaQuery.of(context).size.height * 0.6,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(children: [Back3Bt(), Iconperson()]),
                          OtpHeadText(),
                          OtpFormEdit(),

                          // <<<--- [TASK 20 - เริ่มแก้ไข] ---
                          // (เปลี่ยน Expanded เป็น SizedBox)
                          // Expanded(child: SizedBox()),
                          const SizedBox(height: 16), // <<< (แทนที่)
                          
                          OtpLogo(),
                          
                          // (เปลี่ยน Expanded เป็น SizedBox)
                          // Expanded(child: SizedBox()),
                          const SizedBox(height: 16), // <<< (แทนที่)
                          // <<<--- [TASK 20 - สิ้นสุดการแก้ไข] ---
                          
                          OtpBt(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}