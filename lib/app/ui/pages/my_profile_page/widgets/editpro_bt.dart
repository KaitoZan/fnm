import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../edit_profile_page/edit_profile_page.dart';



class Editprobt extends StatelessWidget {
  const Editprobt({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Get.to(() => EditProfilePage());
          Get.toNamed(AppRoutes.EDITPROFILE);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          padding: EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'แก้ไขข้อมูล',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
