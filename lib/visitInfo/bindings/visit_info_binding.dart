import 'package:get/get.dart';

import '../controllers/visit_info_controller.dart';

class VisitInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<visitInfoController>(
      () => visitInfoController(),
    );
  }
}
