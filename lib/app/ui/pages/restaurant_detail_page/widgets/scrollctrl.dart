import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollpageController extends GetxController {
  late ScrollController scrollController;
  final RxBool showScrollToTopButton = false.obs;
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.onClose();
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    if (scrollController.offset >= 300 && !showScrollToTopButton.value) {
      showScrollToTopButton.value = true;
    } else if (scrollController.offset < 300 && showScrollToTopButton.value) {
      showScrollToTopButton.value = false;
    }
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void resetScrollButtonState() {
    showScrollToTopButton.value = false;
  }
}
