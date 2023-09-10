import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoaderDialog({String? loadingText}) {
  AlertDialog alertDialog = AlertDialog(
    content: Container(
      child: Row(
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(width: 10,),
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
      },);
}