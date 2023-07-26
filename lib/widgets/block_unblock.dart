
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api_helper_service.dart';
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

}