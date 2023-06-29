import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/constants.dart';
import 'package:partypeopleindividual/otp/model/otp_model.dart';

import '../../api_helper_service.dart';
import '../../individual_profile/views/individual_profile.dart';

class OTPController extends GetxController {
  RxString otp = ''.obs;
  RxString header = ''.obs;
  APIService apiService = Get.put(APIService());

// Error Message Helper Function
  String generateErrorMessage(String otp) {
    String errorMessage = '';
    if (otp.isEmpty) {
      errorMessage += 'OTP is required.\n';
    }
    return errorMessage;
  }

  Future<void> otpVerify() async {
    String errorMessage = generateErrorMessage(otp.value);

    if (errorMessage.isNotEmpty) {
      Get.snackbar(loginFailedTitle, errorMessage);
      return;
    }

    try {
      OTPVerificationResponse? response =
          await apiService.verifyOTP(otp.value, header.value);

      if (response.data.phone.isEmpty || response.data.token.isEmpty) {
        Get.snackbar(loginFailedTitle, unexpectedErrorMessage);
      } else {
        ///Login Successfully
        ///Differentiate User Between Organisation and Individual
        print(
            "Checking token on successfull otp verification : ${response.data.token}");
        // Save token to local storage
        await GetStorage().write('token', response.data.token);
        updateUserType();

        Get.snackbar(loginSuccessTitle, loginSuccessMessage);
        Get.offAll(const IndividualProfile());
      }
    } catch (e) {
      Get.snackbar(loginFailedTitle, checkCredentialsMessage);
    } finally {}
  }

  updateUserType() async {
    try {
      Response? response =
          await apiService.updateUserType('Individual', header.value);
      print("userType Udate : ${response?.body}");
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {}
  }
}
