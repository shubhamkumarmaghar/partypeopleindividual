import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoaderDialog({String? loadingText}) {
  AlertDialog alertDialog = AlertDialog(
    content: Container(
      child: Row(
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(
            width: 10,
          ),
          Text(loadingText ?? 'Loading...')
        ],
      ),
    ),
  );
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return alertDialog;
    },
  );
}

Widget getBackBarButton({required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
        alignment: Alignment.bottomLeft,
        child: CircleAvatar(
          child: Icon(
            Icons.arrow_back,
            color: Colors.red.shade900,
          ),
          backgroundColor: Colors.grey.shade200,
        )),
  );
}

double get getScreenHeight => Get.size.height;

double get getScreenWidth => Get.size.width;

void showExitAlertDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(
          left: Get.width * 0.05,
          top: Get.width * 0.02,
          right: Get.width * 0.05,
        ),
        title: Text(
          'Exit',
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'do you want to exit the app?',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
          ),
        ],
      );
    },
  );
}
