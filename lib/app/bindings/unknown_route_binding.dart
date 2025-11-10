import 'package:get/get.dart';

import '../ui/pages/unknown_route_page/unknown_route_controller.dart';

class UnknownRouteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnknownRouteController>(() => UnknownRouteController());
    // Get.put<UnknownRouteController>(UnknownRouteController());
  }
}
