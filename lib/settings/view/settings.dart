import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/settings/controllers/settings_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  Settings({
    Key? key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  SettingController settingController = Get.put(SettingController());
  bool isprivacySwitched =  false;
  bool isnotificationSwitched = false;

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isprivacySwitched =  GetStorage().read("privacy_online_status");
    isnotificationSwitched =  GetStorage().read("online_notification_status") ;
    print("isprivacyswitch :$isprivacySwitched"  + "    isnotification : $isnotificationSwitched");

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar:
          AppBar(
            shape: Border(
              bottom: BorderSide(color: const Color(0xFFc4c4c4), width: 1.sp),
            ),
            backgroundColor: Colors.transparent,
            // Set the background color to transparent
            leading: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Get.back();
              },
              iconSize: 12.sp,
            ),
            titleSpacing: 0,
            elevation: 0,
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink,
                    Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: ListView(children: [

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 8.0,
                      shape:
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink,
                              Colors.red.shade900],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child:
                        Row(
                          children: [
                            Icon(
                              Icons.privacy_tip_outlined,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,children: [  Text(
                                "Online Status",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins'),
                              ),
                                Text(
                                "Your Profile will be hidden when it turn on ",
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins'),
                              ),

                              ],),
                            ),

                            Switch(value: isprivacySwitched,
                              onChanged: (value) {
                              print("value ------------$value");
                                settingController.updatePrivacyStatus(value);
                                GetStorage().write("privacy_online_status", value);
                                setState(() {
                                  isprivacySwitched = value;
                                  print('$isprivacySwitched ${GetStorage().read(
                                      'privacy_online_status')}');
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 8.0,
                      shape:
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink,
                              Colors.red.shade900],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Text(
                                "Notifications",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins'),
                              ),
                                Text(
                                  "Your will not receive notification when it turn Off ",
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                ),

                              ],),
                            ),

                            Switch(
                              value: isnotificationSwitched,
                              onChanged: (value) {
                                log("changed $isnotificationSwitched    $value");
                                settingController.updateNotificationStatus(value);
                                GetStorage().write(
                                    "online_notification_status", value);
                                setState(() {
                                  isnotificationSwitched = value;
                                  print(isnotificationSwitched);
                                  print("${GetStorage().read(
                                      "online_notification_status")}");
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      //deleteaccount(context);
                      showDeleteAlertDialog();
                    },
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 8.0,
                        shape:
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        clipBehavior: Clip.antiAlias,
                        child:
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink,
                                Colors.red.shade900],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0,
                              horizontal: 24.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 24.0,
                                color: Colors.white,
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  "Delete My Account",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }


  void showDeleteAlertDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Delete Your Account?',
      desc: 'Are you sure you want to delete your Account?',
      titleTextStyle: TextStyle(fontSize: 22,color: Colors.black),
      descTextStyle: TextStyle(fontSize: 18,color: Colors.black54),
      btnOkText: "Delete",
      btnOkOnPress: () {
       settingController.deleteAccount();
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }
}
class CustomOptionWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool deleteAccount;
  final VoidCallback? onTap;

  CustomOptionWidget({
    required this.icon,
    required this.title,
    required this.deleteAccount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 8.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade800,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24.0,
                  color: Colors.white,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins'),
                  ),
                ),
                deleteAccount==false?Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16.0,
                  color: Colors.white,
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
