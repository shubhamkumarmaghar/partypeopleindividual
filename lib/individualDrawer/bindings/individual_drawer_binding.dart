import 'package:get/get.dart';

import '../controllers/individual_drawer_controller.dart';

class IndividualDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndividualDrawerController>(
      () => IndividualDrawerController(),
    );
  }
}
