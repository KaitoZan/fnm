import 'package:flutter/material.dart';


import 'package:food_near_me_app/app/ui/pages/splash_page/splash_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/backgoundsplash.dart';
import '../../global_widgets/loadingcircle.dart';

class SplashPage extends GetView<SplashController> {
  SplashPage({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(child: Backgoundsplash()),
          Center(child: LoadingCircle()),
        ],
      ),
    );
  }
}
