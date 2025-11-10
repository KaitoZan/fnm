import 'package:flutter/material.dart';

import 'package:food_near_me_app/app/ui/pages/forgot_password_page/forgot_password_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/backgoundlogin.dart';
import '../../global_widgets/blurcontainer.dart';
import '../../global_widgets/iconperson.dart';
import 'widgets/forgot_form_edit.dart';
import 'widgets/forgot_head_text.dart';
import 'widgets/forgot_sent_bt.dart';
import 'widgets/mockup_robot_test.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  ForgotPasswordPage({super.key});

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
                      // <<<--- [TASK 11.2 - แก้ไข] ลบบรรทัด height
                      // height: MediaQuery.of(context).size.height * 0.6,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(children: [Back3Bt(), Iconperson()]),
                          ForgotHead(),
                          SizedBox(height: 5),
                          ForgotFormEdit(),
                          SizedBox(height: 8 * 3),
                          Mockrobot(),

                          Expanded(child: SizedBox()),
                          ForgotSentBt(),
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