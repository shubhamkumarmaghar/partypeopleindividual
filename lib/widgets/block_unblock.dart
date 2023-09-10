
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

import '../api_helper_service.dart';
import '../individualDashboard/controllers/individual_dashboard_controller.dart';
import '../login/views/login_screen.dart';
class Alertdialogs {
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
        api.doBlockUnblockPeople(user_id ?? '', status);
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
       // Navigator.pop(context);
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
      GetStorage().remove('plan_plan_expiry');
      GetStorage().remove('newUser');
      GetStorage().remove('plan_plan_expiry');
      GetStorage().remove('approval_status');
      Get.find<IndividualDashboardController>().timer.cancel();
      Get.offAll(LoginScreen());
    },
    btnCancelText: "Cancel",
    btnCancelOnPress: () {
    //  Navigator.pop(context);
    },
  ).show();
}
/*
showDialogBox() {
  {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.BOTTOMSLIDE,
      // body: Lottie.network('https://assets-v2.lottiefiles.com/a/8f22f7ac-1171-11ee-97a9-4fee365785e2/SWHrZKp2ss.json'),
      title: 'No Connection',
      desc: 'Please check your internet connectivity',
      titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
      descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
      btnOkText: "Ok",
      btnOkOnPress: () async {
        Navigator.pop(context, 'Cancel');
        setState(() => isAlertSet = false);
        isDeviceConnected =
        await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      },

    ).show();
  }
}*/

/// remove people from chat list
  static  Future<void> showDeleteAlertDialog(BuildContext context,String user_id, String status,Function onDelete,Function onDeleteAllChat
      ) async {
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
        api.deleteChatPeople(user_id ?? '',(){
          //onDeleteAllChat();
          onDelete();
        });


      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        // Navigator.pop(context);
      },
    ).show();
  }


  static  Future<void> DeleteAllChatAlertDialog(BuildContext context,Function onDeleteAllChat
      ) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete All Chat?',
      desc: 'Are you sure you want to Delete All chat ?',
      titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
      descTextStyle: TextStyle(fontSize: 18, color: Colors.black54),
      btnOkText: "Delete",
      btnOkOnPress: () {
          onDeleteAllChat();
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        // Navigator.pop(context);
      },
    ).show();
  }
}