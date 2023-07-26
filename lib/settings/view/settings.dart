import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/edit_individual_profile/edit_individual_profile.dart';
import 'package:partypeopleindividual/individual_blocked_report/view/blocked_report_screen.dart';
import 'package:partypeopleindividual/login/views/login_screen.dart';
import 'package:partypeopleindividual/visitInfo/views/visit_info_view.dart';
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
  bool isprivacySwitched = GetStorage().read("online_status") ?? false;
  bool isnotificationSwitched = GetStorage().read(
      "online_notification_status") ?? false;

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> updateonlineStatus(status) async {
    // API endpoint URL
    String url = 'http://app.partypeople.in/v1/account/update_online_status';

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'online_status': status == true ? "on" : "off",
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('status successfullu updated');
      } else {
        // Request failed
        print(
            'Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while updating status: $e');
    }
  }

  Future<void> updatenotificationStatus(status) async {
    // API endpoint URL
    String url = 'http://app.partypeople.in/v1/account/update_notification_status';

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'notification_status': status == true ? "on" : "off",
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Notification status successfullu updated');
      } else {
        // Request failed
        print(
            'Failed to update Notification status. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while updating Notification status: $e');
    }
  }

  Future<void> deleteaccount() async {
    // API endpoint URL
    String url = 'http://app.partypeople.in/v1/account/delete_my_account';

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body not required

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Account Successfully Deleted');
        GetStorage().remove('token');
        GetStorage().remove('loggedIn');
        GetStorage().remove('online_status');
        GetStorage().remove('online_notification_status');

        Get.offAll(const LoginScreen());
      } else {
        // Request failed
        print(
            'Failed to Delete account. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            leading: BackButton(
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.red.shade900,
            elevation: 0,
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
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
                  /*  CustomOptionWidget(
                    title: 'Privacy',
                    icon: Icons.privacy_tip_outlined,
                    deleteaccount: false,
                    onTap: () => Get.to(EditIndividualProfile()),
                  ), */
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
                            colors: [
                              Colors.red.shade400,
                              Colors.red.shade800,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.privacy_tip_outlined,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                "Privacy",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins'),
                              ),
                            ),
                            Switch(value: isprivacySwitched,
                              onChanged: (value) {
                                updateonlineStatus(value);
                                GetStorage().write("online_status", value);
                                setState(() {
                                  isprivacySwitched = value;
                                  print('$isprivacySwitched ${GetStorage().read(
                                      'online_status')}');
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
                  /* CustomOptionWidget(
                    title: 'Notifcations',
                    icon: Icons.notifications_active_outlined,
                    deleteaccount: false,
                    onTap: () {
                      Get.to(VisitInfoView());
                    },
                  ),*/
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
                            colors: [
                              Colors.red.shade400,
                              Colors.red.shade800,
                            ],
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
                              child: Text(
                                "Notifications",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins'),
                              ),
                            ),
                            Switch(
                              value: isnotificationSwitched,
                              onChanged: (value) {
                                updatenotificationStatus(value);
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

                  /* CustomOptionWidget(
                    title: 'Delete My Account',
                    icon: Icons.delete_outline,
                    deleteaccount: true,
                    onTap: () {
                      Get.to(BlockedReportedUsersView());
                    },
                  ),*/
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
                                      fontSize: 13.sp,
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
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete Your Account?',
      desc: 'Are you sure you want to delete your Account?',
      titleTextStyle: TextStyle(fontSize: 22,color: Colors.black),
      descTextStyle: TextStyle(fontSize: 18,color: Colors.black54),
      btnOkText: "Delete",
      btnOkOnPress: () {
       deleteaccount();
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
  bool deleteaccount;
  final VoidCallback? onTap;

  CustomOptionWidget({
    required this.icon,
    required this.title,
    required this.deleteaccount,
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
                deleteaccount==false?Icon(
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
