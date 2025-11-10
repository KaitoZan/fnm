import 'package:flutter/material.dart';

import 'package:food_near_me_app/app/ui/pages/register_page/register_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import '../../global_widgets/backgoundlogin.dart';
import '../../global_widgets/blurcontainer.dart';
import 'widgets/register_bt.dart';
import 'widgets/register_form_edit.dart';
import 'widgets/register_head_text.dart';
import 'widgets/register_image_profile_insert.dart';


class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

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
                    Blurcontainer(
                      width: MediaQuery.of(context).size.width * 0.88,
                      height: MediaQuery.of(context).size.height * 0.65,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [Back3Bt(), RegisterImageProfileInsert()],
                          ),

                          Expanded(child: SizedBox()),
                          RegisterHeadText(),
                          Expanded(child: SizedBox()),
                          RegisterFormEdit(),
                          Expanded(child: SizedBox()),

                          RegisterBt(),
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
