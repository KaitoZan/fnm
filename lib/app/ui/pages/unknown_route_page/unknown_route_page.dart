import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'unknown_route_controller.dart';

class UnknownRoutePage extends GetView<UnknownRouteController> {
  UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnknownRoute'),
      ),
      body: const Center(
        child: Text('UnknownRoute'),
      ),
    );
  }
}
