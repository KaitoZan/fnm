import 'package:flutter/material.dart';

import 'package:food_near_me_app/app/ui/pages/favourite_page/favourite_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/appbarA.dart';
import '../../global_widgets/bt_scrolltop.dart';
import '../../global_widgets/search_bar_filter.dart';
import '../restaurant_detail_page/widgets/scrollctrl.dart';
import 'widgets/show_favourite_card.dart';

class FavouritePage extends GetView<FavouriteController> {
  FavouritePage({super.key});

 @override
  Widget build(BuildContext context) {
    final ScrollpageController scrollpageController = Get.find<ScrollpageController>(tag: 'favorite_scroll');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.pink[200],
        appBar:  AppbarA(tag: 'favorite filter ctrl',),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue[200]!,
              Colors.pink[200]!,
            ]),
          ),
          child: Stack(
            children: [
              Column(
                children: [
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
                        padding: const EdgeInsets.only(top: 10),
                        child: SingleChildScrollView(
                          controller: scrollpageController.scrollController,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               SearchBarFilter(tag:'favorite'),
                              const SizedBox(height: 8),

                              ShowFavouriteCard(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
             BtScrollTop(tag: 'favorite_scroll'),
            ],
          ),
        ),
      ),
    );
  }
}