import 'package:get/get.dart';

import '../controllers/individual_dashboard_controller.dart';

class IndividualDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndividualDashboardController>(
      () => IndividualDashboardController(),
    );
  }
}
