import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_page.dart';
import 'package:get/get.dart';

import '../../global_widgets/back_bt.dart';
import '../../global_widgets/backgoundlogin.dart';
import '../../global_widgets/blurcontainer.dart';
import '../../global_widgets/iconperson.dart';
import 'login_controller.dart';
import 'widgets/login_bt.dart';
import 'widgets/login_form.dart';
import 'widgets/login_head_text.dart';
import 'widgets/login_path_bt.dart';
import 'widgets/login_with_bt.dart';

class LoginPage extends GetView<LoginController> {
   LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            Positioned.fill(child: Backgoundlogin()),
            Center(
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
                          Stack(
                            children: [
                              BackBt(srcp: () => NavbarPage()),
                              Iconperson(),
                            ],
                          ),

                          LoginHeadText(),

                          LoginForm(),
                          LoginPathBt(),
                          LoginWithBt(),

                          LoginBt(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}