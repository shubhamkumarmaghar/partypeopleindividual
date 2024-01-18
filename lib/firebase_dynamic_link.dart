import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/splash_screen/view/splash_screen.dart';


class FirebaseDynamicLinkPostType {
  static final String VIDEO_POST = 'video_post';
  static final String IMAGE_POST = 'image_post';
  static final String PROFILE = 'profile';
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
    if (storage.read('loggedIn') != null) {
      if (link.endsWith(FirebaseDynamicLinkPostType.IMAGE_POST)) {
        print("image post opened ");
        String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.IMAGE_POST}", "").replaceAll("/", "");
      //  Get.to(ImagePostDetailScreen(postId: int.parse(id)), arguments: int.parse(id));
      } else if (link.endsWith(FirebaseDynamicLinkPostType.VIDEO_POST)) {
        print("video post opened ");
        String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.VIDEO_POST}", "").replaceAll("/", "");
      //  Get.to(PostVideoPlayerViewPage(postId: int.parse(id)), arguments: int.parse(id));
      } else if (link.endsWith(FirebaseDynamicLinkPostType.PROFILE)) {
        try {
          String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.PROFILE}", "").replaceAll("/", "");
        //  Get.to(() => UserProfileView(id: int.parse(id),), arguments: int.parse(id));
          print(("profile id $id"));
        } catch (e) {
          print(("${e.toString()}"));
        }
      } else {
     //   Get.to(() => BottomNavigationScreen());
      }
    } else {
     // Get.offAll(() => SocialMediaOptions());
    }
  }

  static getDynamicLinkPage(String link) {
    GetStorage storage = GetStorage();
    if (storage.read("loggedIn") != null) {
      if (link.endsWith(FirebaseDynamicLinkPostType.IMAGE_POST)) {
        print("image post opened ");
        String? id = link.replaceAll("/${FirebaseDynamicLinkPostType.IMAGE_POST}", "").replaceAll("/", "");
       // return ImagePostDetailScreen(postId: int.parse(id));
        return SplashScreen();
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