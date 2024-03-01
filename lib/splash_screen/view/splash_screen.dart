import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:partypeopleindividual/splash_screen/splash_controller/spalash_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../centralize_api.dart';
import '../../individualDashboard/views/individual_dashboard_view.dart';
import '../../login/views/login_screen.dart';
import '../get_version_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = Get.put(SplashController());
  GetVersion? getVersionData;
  @override
  void initState() {
  /*  Future( () => iosUpdater());
    //updaterApp();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      //Get.offAll(const LoginScreen());
      Get.offAll( GetStorage().read('loggedIn') == '1'
          ? const IndividualDashboardView()
          : const LoginScreen());
    });*/
    runApp();
    super.initState();
  }

  runApp() async {
    await _initPackageInfo();
    await Future( () => updaterApp());

   await Future.delayed(const Duration(seconds: 3)).then((value) {
      //Get.offAll(const LoginScreen());
      Get.offAll( GetStorage().read('loggedIn') == '1'
          ? const IndividualDashboardView()
          : const LoginScreen());
    });
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
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  void updaterApp() async
  {
    if(Platform.isIOS){
     await iosUpdater();
    }
    if(Platform.isAndroid){
    await androidUpdater();}
  }
  Future<void> androidUpdater()async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        log('updateInfo.updateAvailability ${updateInfo.updateAvailability}');
        if (updateInfo.immediateUpdateAllowed) {
          log('updateInfo.immediateUpdateAllowed ${updateInfo
              .immediateUpdateAllowed}');
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              log('appUpdateResult ${appUpdateResult}');
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          log('updateInfo.flexibleUpdateAllowed ${updateInfo
              .flexibleUpdateAllowed}');
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
  int getExtendedVersionNumber(String version) {
    try {
      List versionCells = version.split('.');
      versionCells = versionCells.map((i) => int.parse(i)).toList();
      return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
    }
    catch(e)
    {
      print('error :: $e');
      return 101;
    }
  }

  iosUpdater() async{

     String res = await getVersion();

  // var currentVersion = getExtendedVersionNumber('${_packageInfo.version}');
    //var getVersion = getExtendedVersionNumber('${getVersionData?.data?.version}');
    log('data $res  ${getVersionData?.data?.version}   ${_packageInfo.version}  ${getExtendedVersionNumber('${getVersionData?.data?.version}')}  ${getExtendedVersionNumber('${_packageInfo.version}')} ');
    if(res == 'true' && getExtendedVersionNumber('${getVersionData?.data?.version}') > getExtendedVersionNumber('${_packageInfo.version}'))
    {
      log('data $res');
      // flutter defined function
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Update app!"),
            content: new Text('${getVersionData?.data?.ffUpdateMsg}'),
            actions: <Widget>[
              CupertinoDialogAction(
                  //isDefaultAction: true,
                  onPressed: () async {
          Get.back();
          },
                  child: const Text('Ignore'),),
              CupertinoDialogAction(
                //isDefaultAction: true,
                onPressed: () async {
                  final Uri _url =
                  await Uri.parse("https://apps.apple.com/app/party-peoples/id6471072076");
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                  Get.back();
                },
                child: const Text('Update'),),
              // usually buttons at the bottom of the dialog

            ],
          );
        },
      );
    }
    else{
      print('No Version data found');
    }

  }

  Future<String> getVersion() async {
    String url =API.getVersion+'?os_type=ios';
    final response = await http.get(
      Uri.parse(url),
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    log('${jsonResponse}');
    if(jsonResponse['status']==1){
      var versionResponse = GetVersion.fromJson(jsonResponse);
      getVersionData = versionResponse;
      log('cheking ${getVersionData?.data?.ffUpdateMsg}');
      return 'true';
    }
    else{
      log('checking false');
      return 'false';
    }
  }
}

