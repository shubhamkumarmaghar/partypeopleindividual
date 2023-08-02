
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../api_helper_service.dart';
import '../login/views/login_screen.dart';
class BlockUnblock {
static  void showBlockedAlertDialog(BuildContext context,String user_id, String status,
      ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.BOTTOMSLIDE,
      title: '$status this user?',
      desc: 'Are you sure you want to $status this user ?',
      titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
      descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
      btnOkText: "$status",
      btnOkOnPress: () {
        APIService api = APIService();
        api.DoBlockUnblockPeople(user_id ?? '', status);
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }


static  void showLogoutAlertDialog(BuildContext context
    ) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Logout ? ',
    desc: 'Are you sure you want to Logout ',
    titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
    descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
    btnOkText: "Log out",
    btnOkOnPress: () {
      GetStorage().remove('token');
      GetStorage().remove('loggedIn');
      GetStorage().remove('online_status');
      GetStorage().remove('online_notification_status');
      Get.offAll(LoginScreen());
    },
    btnCancelText: "Cancel",
    btnCancelOnPress: () {
    //  Navigator.pop(context);
    },
  ).show();
}

}