import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainLayout extends GetView<MainController> {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Food_app'),
      //   ),
      body: Column(
        children: [
          Expanded(child: child),
        ],
      ),
    );
  }
}
