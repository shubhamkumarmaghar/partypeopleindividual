import 'dart:async';
import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../../firebase_dynamic_link.dart';
import '../../individualDashboard/views/individual_dashboard_view.dart';
import '../../login/views/login_screen.dart';
import '../view/splash_screen.dart';


var staticBottomIndex = 0;
String dataLink = "";

class SplashController extends GetxController {
  var link;

  SplashController();

  AnimationController? animationController;
  Animation<double>? animation;

  bool permission = false;
  StreamSubscription? intentDataStreamSubscription;

  var page;

  updatePage(nav) {
    page = nav;
    update();
    // debugPrint('Splash update Global variable page is: ${GlobalVariable().pageTo}');
  }

  updateLink(var linkIS) {
    link = linkIS;
    debugPrint('Splash update Func Link value is: $link ( $linkIS )');
    update();
  }

  bool isdarkMode = false;

  @override
  void onInit() async {

    initDynamicLinks();
    receiveUrl();
    receiveUrlWhenAppClosed();
    debugPrint('Splash init Link value is: $link');
    staticBottomIndex = 0;
 //   var controller = Get.put(MainController());
   // if (controller.comingFromNotification != true && link == null) {
      if (link == null) {
      // callMethod();
      _navigateToNextScreen();
    }

    // await getPermission([
    //   Permission.microphone,
    //   Permission.location,
    //   Permission.camera,
    //   Permission.bluetoothConnect,
    //   Permission.bluetooth,
    // ]);

    super.onInit();
  }

  init() {}

  receiveUrl() {
    staticBottomIndex = 0;

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    // intentDataStreamSubscription =
    //     ReceiveSharingIntent.getTextStream().listen((String value) {
    //   staticBottomIndex = 1;
    //   dataLink = value;
    //   debugPrint("Shared link: $dataLink");
    //   Get.offAll(() => BottomNavigationScreen());
    //   debugPrint("Shared link: $staticBottomIndex");
    //   debugPrint("Shared link: $dataLink");
    //   update();
    // }, onError: (err) {
    //   print("getLinkStream error: $err");
    // });
    // update();
  }

  receiveUrlWhenAppClosed() {
    // For sharing or opening urls/text coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialText().then((String? value) {
    //   if (value != null) {
    //     staticBottomIndex = 1;
    //     dataLink = value;
    //     Get?.offAll(() => BottomNavigationScreen());
    //     debugPrint("Shared link: $staticBottomIndex");
    //     debugPrint("Shared link: $dataLink");
    //   } else {
    //     staticBottomIndex = 0;
    //   }
    //   update();
    // });
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      log('deeplink from listen::::::: ${dynamicLinkData.link} ,'
          'user info:: ${dynamicLinkData.link.userInfo}'
          '${dynamicLinkData.link.path} , '
          '${dynamicLinkData.link.authority}    ,'
          ' ${dynamicLinkData.link.data} '
          '${dynamicLinkData.link.origin},'
          '${dynamicLinkData.link.query}  '
          '${dynamicLinkData.link.queryParametersAll}  ');

      FirebaseDynamicLinkUtils.handleDynamicLink(dynamicLinkData.link.toString());
    }).onError((error) {
      log("error is ${error?.message?.toString()}");
    });
  }

  _navigateToNextScreen() => Timer(Duration(seconds: 5), () async {
    String data = await GetStorage().read("loggedIn") ??'';
    if (data != null) {
      await hitCheckApi();
    } else {
      await Future.delayed(const Duration(seconds: 3)).then((value) {
        //Get.offAll(const LoginScreen());
        Get.offAll( GetStorage().read('loggedIn') == '1'
            ? const IndividualDashboardView()
            : const LoginScreen());
      });
    }
  });

  hitCheckApi() async {
    print("Splash hitCheckApi");
    debugPrint('Splash Navigate Link value is: $link');
    if (link != null) {
      FirebaseDynamicLinkUtils.handleDynamicLink(link.link.path.toString());
    } else {
      await Future.delayed(const Duration(seconds: 3)).then((value) {
        //Get.offAll(const LoginScreen());
        Get.offAll( GetStorage().read('loggedIn') == '1'
            ? const IndividualDashboardView()
            : const LoginScreen());
      });
    }
    update();
  }
/*
  Future<void> getPermission(List<Permission> permissionType) async {
    if (await Permission.camera.request().isDenied) {
      // toast('${Strings.needPermissionFor} Camera');
      await Permission.camera.request();
    }
    if (await Permission.location.request().isDenied) {
      // toast('${Strings.needPermissionFor} Location');
      await Permission.location.request();
    }

    if (await Permission.microphone.request().isDenied) {
      // toast('${Strings.needPermissionFor} Microphone');
      await Permission.microphone.request();
    }

    if (await Permission.bluetoothConnect.request().isDenied) {
      // toast('${Strings.needPermissionFor} Microphone');
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetooth.request().isDenied) {
      // toast('${Strings.needPermissionFor} Microphone');
      await Permission.bluetooth.request();
    }

    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus microphoneStatus = await Permission.location.status;
    PermissionStatus locationStatus = await Permission.microphone.status;

    // if (cameraStatus.isPermanentlyDenied ||
    //     microphoneStatus.isPermanentlyDenied ||
    //     locationStatus.isPermanentlyDenied) {
    //   openAppSettings();
    // }

    // await permissionType.request().then((value) async {
    //   if (value[Permission.microphone]!.isGranted &&
    //       value[Permission.camera]!.isGranted &&
    //       value[Permission.location]!.isGranted) {
    //     permission = true;
    //   }
    //   debugPrint(value.toString());
    //   if (value[Permission.microphone]!.isPermanentlyDenied ||
    //       value[Permission.camera]!.isPermanentlyDenied ||
    //       value[Permission.location]!.isPermanentlyDenied) {
    //     openAppSettings();
    //     toast('${Strings.needPermissionFor} ${permissionType}');
    //   }
    // }).onError((error, stackTrace) {
    //   print(error.toString());
    // });
  }
*/
  @override
  void dispose() {
    super.dispose();
  }
}