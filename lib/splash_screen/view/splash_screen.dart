import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:partypeopleindividual/login/views/login_screen.dart';

import '../../individualDashboard/views/individual_dashboard_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    updaterApp();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      //Get.offAll(const LoginScreen());
      Get.offAll(GetStorage().read('loggedIn') == '1' ? const IndividualDashboardView() : const LoginScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/splashscreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void updaterApp() async
  {
    await appUpdater();
  }

  Future<void> appUpdater() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        log('updateInfo.updateAvailability ${updateInfo.updateAvailability}');
        if (updateInfo.immediateUpdateAllowed) {
          log('updateInfo.immediateUpdateAllowed ${updateInfo.immediateUpdateAllowed}');
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              log('appUpdateResult ${appUpdateResult}');
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          log('updateInfo.flexibleUpdateAllowed ${updateInfo.flexibleUpdateAllowed}');
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              log('appUpdateResult ${appUpdateResult}');
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }

}

