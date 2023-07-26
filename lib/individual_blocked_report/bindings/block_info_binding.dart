import 'package:get/get.dart';

import '../controllers/block_info_controller.dart';

class VisitInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockReportController>(
      () => BlockReportController(),
    );
  }
}
