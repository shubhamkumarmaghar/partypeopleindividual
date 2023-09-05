import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/constants.dart';
import 'package:partypeopleindividual/otp/model/otp_model.dart';
import 'package:http/http.dart' as http;
import '../../api_helper_service.dart';
import '../../individualDashboard/views/individual_dashboard_view.dart';
import '../../individual_profile/views/individual_profile.dart';
import '../../login/views/login_screen.dart';

class OTPController extends GetxController {
  RxString otp = ''.obs;
  RxString header = ''.obs;
  RxBool isLoading = false.obs;
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
      if(response != null){
        if (response.data.phone.isEmpty || response.data.token.isEmpty) {
          Get.snackbar(loginFailedTitle, unexpectedErrorMessage);
        }
        else if(response.data.type=='Individual' && response.data.phone.isNotEmpty && response.data.token.isNotEmpty){
          ///Login Successfully
          ///Differentiate User Between Organisation and Individual
          print(
              "Checking token on successfull otp verification : ${response.data.token}");
          // Save token to local storage
          await GetStorage().write('token', response.data.token);
          updateUserType();
          Get.snackbar(loginSuccessTitle, loginSuccessMessage);
          getAPIOverview();
          //Get.offAll(const IndividualProfile());
        }
        else if(response.message == 'Sorry ! you can not login here' && response.status == 0)
        {
          Get.snackbar(loginFailedTitle, organizationUser);
          Get.to(LoginScreen());
        }
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

  ///Check weather user has already filled the data or not
  getAPIOverview() async {
    isLoading.value = true;
    try {
      http.Response response = await http.post(
          Uri.parse('https://app.partypeople.in/v1/party/organization_details'),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });
      print("response of Organization ${response.body}");

      if (jsonDecode(response.body)['message'] == 'Organization Data Found.') {
        GetStorage().write('loggedIn', '1');
        isLoading.value = false;
       Get.offAll(IndividualDashboardView());
      } else {
        isLoading.value = false;
        Get.offAll(const IndividualProfile());
      }
    } on Exception catch (e) {
      print('Exception in Login View ${e}');
    }
    isLoading.value = false;
  }

}
