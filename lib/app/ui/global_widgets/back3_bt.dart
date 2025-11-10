import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_page.dart';
import 'package:get/get.dart';



class Back3Bt extends StatelessWidget {
  const Back3Bt({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 8.0*2),
      onPressed: () {
        FocusScope.of(Get.context!).unfocus();
        if (Get.previousRoute.isNotEmpty) {
          Get.back();
        
        } else {
          // Get.offAll(() => NavbarPage());
          Get.offAllNamed(AppRoutes.NAVBAR);
        }
        
      },
      icon: Image.asset(
        "assets/ics/backicon.png",
        width: 40.0,
        height: 40.0,
        color: Colors.white,
      ),
      
    );
  }
}
