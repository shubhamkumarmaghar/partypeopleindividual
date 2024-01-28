import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/splash_screen/view/splash_screen.dart';

import 'firebase_dynamic_link.dart';

class SettingController extends GetxController{
  var link;
  @override
  void onInit(){
    initDynamicLinks();
    if (link != null) {
      return FirebaseDynamicLinkUtils.getDynamicLinkPage(link);
    }
    super.onInit();
  }

  navigateToNextScreen() async {
    String data = await GetStorage().read("loggedIn") ??'';
    if (data != null) {
      await hitCheckApi();
    } else {
      Get.offAll(const SplashScreen());
    }
  }

  Widget hitCheckApi()  {
    print("Splash hitCheckApi");
    debugPrint('Splash Navigate Link value is: $link');
    if (link != null) {
      return FirebaseDynamicLinkUtils.getDynamicLinkPage(link);
    } else {
        return SplashScreen();
    }
   // update();
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

      // updateLink(dynamicLinkData.link.toString());

      FirebaseDynamicLinkUtils.handleDynamicLink(dynamicLinkData.link.toString());
    }).onError((error) {
      log("error is ${error?.message?.toString()}");
    });
  }

  updateLink(var linkIS) {
    link = linkIS;
    debugPrint('Splash update Func Link value is: $link ( $linkIS )');
    update();
  }

  Widget getPage(){
    return hitCheckApi();
  }

}