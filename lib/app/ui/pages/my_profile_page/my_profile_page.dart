import 'package:flutter/material.dart';

import 'package:food_near_me_app/app/ui/pages/my_profile_page/my_profile_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarB.dart';
import 'widgets/bottom_bt.dart';
import 'widgets/profile_head.dart';
import 'widgets/profileimshow.dart';
import 'widgets/show_profile_detail.dart';

class MyProfilePage extends GetView<MyProfileController> {
  MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const AppbarB(),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.pink[200]!],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 50),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            ProfileHead(),

                            // SizedBox(height: 15)    ,
                            ShowProfileDetail(),

                            // Expanded(child: SizedBox()),
                            // Editprobt(),
                            // SizedBox(height: 15),
                            // Logoutbt(),
                             BottomBt(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Profileimshow(),
            ],
          ),
        ),
      ),
    );
  }
}
