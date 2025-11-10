import 'package:flutter/material.dart';

import 'package:food_near_me_app/app/ui/pages/edit_profile_page/edit_profile_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarB.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart';
import 'widgets/edpf_cancel_bt.dart';
import 'widgets/edpf_form_edit.dart';
import 'widgets/edpf_head_text.dart';
import 'widgets/edpf_profile_insert.dart';
import 'widgets/edpf_save_bt.dart';

class EditProfilePage extends GetView<EditProfileController> {
  EditProfilePage({super.key});

   @override
  Widget build(BuildContext context) {
    final ScrollpageController scrollpageController = Get.find<ScrollpageController>( 
      tag: 'edit_profile_scroll',
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppbarB(),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink[200]!, Colors.blue[200]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  transform: GradientRotation(3.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink[200]!, Colors.blue[200]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        transform: GradientRotation(3.0),
                      ),
                    ),
                  ),
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
                        child: SingleChildScrollView(
                          controller: scrollpageController.scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 60),
                              EdpfHeadText(),
                              const SizedBox(height: 10),
                              EdpfFormEdit(),
                              const SizedBox(height: 70),
                              EdpfSaveBt(),
                              const SizedBox(height: 15),
                              EdpfCancelBt(),

                              // const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BtScrollTop(tag: 'edit_profile_scroll'),
            EditProfileInsert(),
          ],
        ),
      ),
    );
  }
}