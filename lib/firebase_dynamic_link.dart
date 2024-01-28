import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/splash_screen/view/splash_screen.dart';
import 'package:partypeopleindividual/widgets/payment_response_view.dart';

import 'individualDashboard/views/individual_dashboard_view.dart';
import 'individual_party_preview/party_preview_screen_new.dart';
import 'login/views/login_screen.dart';


class FirebaseDynamicLinkPostType {
  static final String VIDEO_POST = 'video_post';
  static final String IMAGE_POST = 'image_post';
  static final String PROFILE = 'profile';
  static final String PARTY = 'party';
}

class FirebaseDynamicLinkUtils {
  static final String DynamicLink = 'https://partypeopleindividual.page.link/dashboard';
  static final String Link = 'https://65.2.59.129/app/v1/party/';
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<String?> createDynamicLink(String type, String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://partypeopleindividual.page.link/dashboard',
      link: Uri.parse(DynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'com.partypeopleindividual',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.partypeople.individual',
        minimumVersion: '0',
      ),
    );

    Uri? url = await dynamicLinks.buildLink(parameters);
    print("url is $url");
    String sharedLink = url.toString() + "/" + id + "/$type";
    return sharedLink;
  }

  static handleDynamicLink(String link) {
    GetStorage storage = GetStorage();
    log("handle party post open : $link");
    if (storage.read('loggedIn') != null && GetStorage().read('loggedIn') == '1' ) {
      if (link.endsWith(FirebaseDynamicLinkPostType.PARTY)) {
        log("handle party post open ");
        var data = link.split("/");
        String? id = data[3];

        log('id::::  $id  $data');
        Get.to(PartyPreviewScreen(id: id,
          //  party: widget.party
        ),arguments:id );
        //  Get.to(ImagePostDetailScreen(postId: int.parse(id)), arguments: int.parse(id));
      }
      else if (link.endsWith(FirebaseDynamicLinkPostType.VIDEO_POST)) {
        print("video post opened ");
        String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.VIDEO_POST}", "").replaceAll("/", "");
      //  Get.to(PostVideoPlayerViewPage(postId: int.parse(id)), arguments: int.parse(id));
      }
      else if (link.endsWith(FirebaseDynamicLinkPostType.PROFILE)) {
        try {
          String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.PROFILE}", "").replaceAll("/", "");
        //  Get.to(() => UserProfileView(id: int.parse(id),), arguments: int.parse(id));
          print(("profile id $id"));
        } catch (e) {
          print(("${e.toString()}"));
        }
      } else {
        Get.offAll(const SplashScreen());
     //   Get.to(() => BottomNavigationScreen());
      }
    } else {
     // Get.offAll(() => SocialMediaOptions());
    }
  }

  static getDynamicLinkPage(String link) {
    GetStorage storage = GetStorage();
    log("get party post open : $link");
    if (storage.read('loggedIn') != null && GetStorage().read('loggedIn') == '1' ) {
      if (link.endsWith(FirebaseDynamicLinkPostType.PARTY)) {
        log("get party post open ");
        var data = link.split("/");
        String? id = data[3];

        log('id:::: from kill  $id  $data');
       /* Get.to(PartyPreviewScreen(id: id,
          //  party: widget.party
        ),arguments:id );*/
       return PartyPreviewScreen(id: id);
        //  Get.to(ImagePostDetailScreen(postId: int.parse(id)), arguments: int.parse(id));
      } else if (link.endsWith(FirebaseDynamicLinkPostType.VIDEO_POST)) {
        print("video post opened ");
        String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.VIDEO_POST}", "").replaceAll("/", "");
        //return PostVideoPlayerViewPage(postId: int.parse(id));
        return SplashScreen();
      } else if (link.endsWith(FirebaseDynamicLinkPostType.PROFILE)) {
        try {
          String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.PROFILE}", "").replaceAll("/", "");
          //return UserProfileView(id: int.parse(id));
          return SplashScreen();
        } catch (e) {
          print(("${e.toString()}"));
        }
      } else {
        return SplashScreen();
      }
    } else {
      return SplashScreen();
    }
  }
}