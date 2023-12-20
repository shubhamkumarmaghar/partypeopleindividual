import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/otp/controller/otp_controller.dart';

import '../../otp/views/otp_view.dart';
import '../model/user_model.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;
  String countryType = '1';
  RxString username = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString email = ''.obs;
  RxString deviceToken = ''.obs;
  APIService apiService = Get.put(APIService());
  OTPController otpController = Get.put(OTPController());

// Constant messages
  static const String loginFailedTitle = 'Login Failed';
  static const String unexpectedErrorMessage =
      'Login failed due to an unexpected error. Please try again.';
  static const String checkCredentialsMessage =
      'Login failed. Check your username and mobile number and try again.';

// Error Message Helper Function
  String generateErrorMessage(
      bool isChecked, String mobileNumber, String username,String email) {
    String errorMessage = '';
    if (username.isEmpty  ) {
      errorMessage += 'Username is required.\n';
    }
   if (username.length > 10  ) {
      errorMessage += 'username should be less then 10 letters.\n';
    }
    if (username.isNumericOnly) {
      errorMessage += 'username should not be numeric value. \n';
    }
    if(countryType =='1'){
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      errorMessage += 'Mobile number should be 10 digits and is required.\n';
    }}
    else{
      if (email.isEmpty  ) {
        errorMessage += 'Please enter valid email Id.\n';
      }}
    if (!isChecked) {
      errorMessage += 'Please accept the terms and conditions.';
    }
    return errorMessage;
  }

  Future<void> login() async {
    String errorMessage = generateErrorMessage(
        isChecked.value, mobileNumber.value, username.value,email.value);

    if (errorMessage.isNotEmpty) {
      Get.snackbar(loginFailedTitle, errorMessage);
      return;
    }

    if(Platform.isIOS) {
      await FirebaseMessaging.instance.getAPNSToken().then((token) {
        log("IOS APNS TOKEN ::  $token");
        deviceToken.value = token!;
      });
    }
    else{
      await FirebaseMessaging.instance.getToken().then((token) {
        print("token is $token");
        deviceToken.value = token!;
      });
    }

    try {
      User? response = await apiService.login(
          username.value, mobileNumber.value,email.value,countryType ,deviceToken.value);

      if (response.phone.isNotEmpty || response.email.isNotEmpty) {
        otpController.header.value = response.token;
        countryType =='1'? GetStorage().write('mobile', mobileNumber.value):GetStorage().write('email', email.value);
        Get.to(OTPScreen(
          enteredNumberOrEmail: countryType =='1' ? mobileNumber.value:email.value,type: countryType,
        ));
      } else {
        Get.snackbar(loginFailedTitle, unexpectedErrorMessage);
      }
    } catch (e) {
      Get.snackbar(loginFailedTitle, checkCredentialsMessage);
    } finally {}
  }
}
