import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/otp/controller/otp_controller.dart';

import '../../otp/views/otp_view.dart';
import '../model/user_model.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;

  RxString username = ''.obs;
  RxString mobileNumber = ''.obs;
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
      bool isChecked, String mobileNumber, String username) {
    String errorMessage = '';
    if (username.isEmpty) {
      errorMessage += 'Username is required.\n';
    }
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      errorMessage += 'Mobile number should be 10 digits and is required.\n';
    }
    if (!isChecked) {
      errorMessage += 'Please accept the terms and conditions.';
    }
    return errorMessage;
  }

  Future<void> login() async {
    String errorMessage = generateErrorMessage(
        isChecked.value, mobileNumber.value, username.value);

    if (errorMessage.isNotEmpty) {
      Get.snackbar(loginFailedTitle, errorMessage);
      return;
    }

    await FirebaseMessaging.instance.getToken().then((token) {
      print("token is $token");
      deviceToken.value = token!;
    });

    try {
      User? response = await apiService.login(
          username.value, mobileNumber.value, deviceToken.value);

      if (response.phone.isEmpty) {
        Get.snackbar(loginFailedTitle, unexpectedErrorMessage);
      } else {
        otpController.header.value = response.token;
        Get.to(OTPScreen(
          enteredNumber: mobileNumber.value,
        ));
      }
    } catch (e) {
      Get.snackbar(loginFailedTitle, checkCredentialsMessage);
    } finally {}
  }
}
