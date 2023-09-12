import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/api_helper_service.dart';

import '../../centralize_api.dart';
import '../../individualDashboard/models/city.dart';
import '../../widgets/submit_application.dart';

class IndividualProfileController extends GetxController {
  RxString coverPhotoURL = ''.obs;
  RxString profilePhotoURL = ''.obs;

  RxString username = ''.obs;
  RxString userMobile = ''.obs;
  RxString userId = ''.obs;
  RxString firstname = ''.obs;
  RxString email = ''.obs;
  RxString lastname = ''.obs;
  RxString bio = ''.obs;
  RxString description = ''.obs;
  RxString dob = ''.obs;
  RxString pincode = ''.obs;
  RxString organization_id = ''.obs;
  RxString occupation = ''.obs;
  RxString qualification = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString gender = ''.obs;
  RxString activeCity = ''.obs;
  RxString city = ''.obs;
  RxString privacyOnlineStatus = ''.obs;
  RxString notification = ''.obs;
  RxString descStatusApproval = ''.obs;
  RxString photoStatusApproval = ''.obs;



  TextEditingController dobController = TextEditingController();
  RxList selectedAmenities = [].obs;
  RxList activeCities = [].obs;
  RxList<IndividualCity> allCityList = RxList();
  var getPrefiledData;
  Map<String, String> userData = {};

  APIService apiService = Get.put(APIService());


  // Add this function to your controller.
  void onContinueButtonPressed() {
    if (coverPhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Cover Photo URL should not be empty');
      return;
    }

    if (profilePhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Profile Photo URL should not be empty');
      return;
    }

    if (firstname.value.isEmpty) {
      Get.snackbar('Name Error', 'First name should not be empty');
      return;
    }
    if (email.value.isEmpty || !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Email  should not be empty');
      return;
    }
    if ( !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Please enter valid email ');
      return;
    }

    if (lastname.value.isEmpty) {
      Get.snackbar('Name Error', 'Last name should not be empty');
      return;
    }

    if (description.value.isEmpty) {
      Get.snackbar('Description Error', 'Description should not be empty');
      return;
    }

    if (dob.value.isEmpty) {
      Get.snackbar('DOB Error', 'Date of birth should not be empty');
      return;
    }

    // Check pincode length and pattern
    if (pincode.value.isEmpty ||
        pincode.value.length != 6 ||
        !isNumeric(pincode.value)) {
      Get.snackbar('Pincode Error',
          'Pincode should be exactly 6 digits and should not contain non-numeric characters');
      return;
    }

    if (occupation.value.isEmpty) {
      Get.snackbar('Occupation Error', 'Occupation should not be empty');
      return;
    }

    if (qualification.value.isEmpty) {
      Get.snackbar('Qualification Error', 'Qualification should not be empty');
      return;
    }

    if (country.value.isEmpty) {
      Get.snackbar('Location Error', 'Country should not be empty');
      return;
    }

    if (activeCity.value.isEmpty) {
      Get.snackbar('Location Error', 'Active City should not be empty');
      return;
    }


    if (state.value.isEmpty) {
      Get.snackbar('Location Error', 'State should not be empty');
      return;
    }

    if (city.value.isEmpty) {
      Get.snackbar('Location Error', 'City should not be empty');
      return;
    }

    // Your API call goes here. Use Get.isSnackbarOpen to avoid triggering the API call if a snackbar is open.
    if (!Get.isSnackbarOpen && apiService.isLoading.value == false) {
      // individualAPI
      userData = {
        'cover_photo': coverPhotoURL.value.toString(),
        'profile_photo': profilePhotoURL.value.toString(),
        'name': firstname.value.capitalize.toString() + ' ' + lastname.value.capitalizeFirst.toString(),
        'bio': description.value.toString(),
        'description':description.value.toString(),
        'dob': dob.value.toString(),
        'email':email.value.toString(),
        'pincode': pincode.value.toString(),
        'occupation': occupation.value.toString(),
        'qualification': qualification.value.toString(),
        'country': country.value.toString(),
        'gender': gender.value.toString(),
        'type': '2',
        'amenities_id': selectedAmenities.join(','),
        'state': state.value.toString(),
        'city': city.value.toString(),
      };

      print(userData);
      individualProfile();
    }
  }

  void onUpdateButtonPressed() {
    if (coverPhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Cover Photo URL should not be empty');
      return;
    }

    if (profilePhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Profile Photo URL should not be empty');
      return;
    }

    if (firstname.value.isEmpty) {
      Get.snackbar('Name Error', 'First name should not be empty');
      return;
    }

    if (lastname.value.isEmpty) {
      Get.snackbar('Name Error', 'Last name should not be empty');
      return;
    }

    if (description.value.isEmpty) {
      Get.snackbar('Bio Error', 'Bio should not be empty');
      return;
    }

    if (email.value.isEmpty || !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Email  should not be empty');
      return;
    }

    if ( !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Please enter valid email ');
      return;
    }


    if (dob.value.isEmpty) {
      Get.snackbar('DOB Error', 'Date of birth should not be empty');
      return;
    }

    // Check pincode length and pattern
    if (pincode.value.isEmpty ||
        pincode.value.length != 6 ||
        !isNumeric(pincode.value)) {
      Get.snackbar('Pincode Error',
          'Pincode should be exactly 6 digits and should not contain non-numeric characters');
      return;
    }

    if (occupation.value.isEmpty) {
      Get.snackbar('Occupation Error', 'Occupation should not be empty');
      return;
    }

    if (qualification.value.isEmpty) {
      Get.snackbar('Qualification Error', 'Qualification should not be empty');
      return;
    }

    if (country.value.isEmpty) {
      Get.snackbar('Location Error', 'Country should not be empty');
      return;
    }

    if (state.value.isEmpty) {
      Get.snackbar('Location Error', 'State should not be empty');
      return;
    }

   /* if (activeCity.value.isEmpty) {
      Get.snackbar('Location Error', 'Active City should not be empty');
      return;
    }*/
    if (city.value.isEmpty) {
      Get.snackbar('Location Error', 'City should not be empty');
      return;
    }

    // Your API call goes here. Use Get.isSnackbarOpen to avoid triggering the API call if a snackbar is open.
    if (!Get.isSnackbarOpen && apiService.isLoading.value == false) {
      // individualAPI
      userData = {
        'cover_photo': coverPhotoURL.value.toString(),
        'profile_photo': profilePhotoURL.value.toString(),
        'name': firstname.value.toString() + ' ' + lastname.value.toString(),
        'email':email.value.toString(),
        'bio': description.value.toString(),
        'description': description.value.toString(),
        'dob': dob.value.toString(),
        'pincode': pincode.value.toString(),
        'occupation': occupation.value.toString(),
        'qualification': qualification.value.toString(),
        'country': country.value.toString(),
        'gender': gender.value.toString(),
        'type': '2',
        'organization_id': organization_id.value.toString(),
        'amenities_id': selectedAmenities.join(','),
        'state': state.value.toString(),
        'city': city.value.toString(),
      };

      individualProfileUpdate();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> individualProfile() async {
    try {
      var response = await apiService.individualProfileCreation(
          userData, '${GetStorage().read('token')}');
      print(response);

      if (response['status'] == 1 &&
          response['message'].contains('Successfully')) {
        Get.offAll(const ShowSubmitMessage());
      }
      else if(
      response['status'] == 2 &&
          response['message'].contains('Organization Already Created.')
      ){
        Get.snackbar('Error', 'Organization Already Created.');
      }else {
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
     log('Network Error : Please check your internet connection and try again!');
    } on HttpException {
  log ('Http Error Could not find the service you were looking for!');
    } on FormatException {
      log('Error Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
   /*   Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');*/
      print('Unexpected error: $e');
    }
  }

  Future<void> individualProfileUpdate() async {
    print('Individual Profile Update :=> $userData');
    try {
      var response = await apiService.individualProfileUpdate(
          userData, '${GetStorage().read('token')}');
      print(response);

      if (response['status'] == 1 &&
          response['message'].contains('Successfully')) {
        Get.offAll(const ShowSubmitMessage());
      } else if(
      response['status'] == 2 &&
          response['message'].contains('Organization Already Created.')
      ){
        Get.snackbar('Error', 'Organization Already Created.');
      }
      else{
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
     log('Network Error : Please check your internet connection and try again!');
    } on HttpException {
      log('Error Could not find the service you were looking for!');
    } on FormatException {
      log('Error Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
    /*  Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!'); */
      print('Unexpected error: $e');
    }
  }

  Future<void> individualProfileData() async {
    try {
      apiService.isLoading.value = true;
      var response = await apiService
          .individualProfileData('${GetStorage().read('token')}');
      print("profile data $response");

      if (response['status'] == 1 &&
          response['message'].contains('Data Found')) {
        try {
          // Try to parse and assign the values
          Map<String, dynamic> user = response['data'][0];

          // Splitting full name into first and last name
          String fullName = user['name'] ?? ' ';
          List<String> nameParts = fullName.split(' ');

          firstname.value = nameParts[0];
          lastname.value = nameParts.length > 1 ? nameParts[1] : '';

          // Assigning the retrieved data to the respective fields
          bio.value = user['bio'] ?? '';
          description.value = user['description'];
          dob.value = user['dob'] ?? '';
          email.value = user['email'] ?? '';
          pincode.value = user['pincode'] ?? '';
          occupation.value = user['occupation'] ?? '';
          qualification.value = user['qualification'] ?? '';
          country.value = user['country'] ?? '';
          state.value = user['state'] ?? '';
          GetStorage().write('state', state.value);
          username.value = response['user_name'];
          userMobile.value = response['user_phone_number'];
          userId.value = user['user_id'];
          gender.value = user['gender'] ?? '';
          getPrefiledData = user['org_amenitie_id']?.split(',');
          print("indi amen :=> $getPrefiledData");
          city.value = user['city'] ?? '';
          profilePhotoURL.value = user['profile_pic'] ?? '';
          coverPhotoURL.value = user['cover_photo'] ?? '';
          organization_id.value = user['id'] ?? "";
          activeCity.value = user['active_city']??'';
          descStatusApproval.value = user['approval_desciption_status']??'';
          photoStatusApproval.value = user['profile_pic_approval_status']??'';
          // Set dobController's text to the 'dob' value
          DateTime date =  DateTime.parse('${dob.value}');
          log('date $date');
          dob.value = DateFormat('dd/MM/yyyy').format(date);
          dobController.text = dob.value;
         // dobController.text = dob.value;
          privacyOnlineStatus.value = response['privacy_online']??'';
          notification.value = response['notification']??'';
          GetStorage().write("my_username", username.value.toString());
          GetStorage().write("my_user_id", userId.value.toString());
          // get status for privacy and notification

          if (privacyOnlineStatus.value
              .toString() ==
              'No') {
            GetStorage().write("privacy_online_status", true);
          } else {
            GetStorage().write("privacy_online_status", false);
          }
         // print("privacy_online_status   ${GetStorage().read("privacy_online_status")}  ${privacyOnlineStatus.value}");
          if (notification.value == 'off') {
            GetStorage().write("online_notification_status", false);
          } else {
            GetStorage().write("online_notification_status", true);
          }

        //  print("online_notification_status   ${GetStorage().read("online_notification_status")}   ${notification.value}");

         log('descStatusApproval ::: ${descStatusApproval.value}');
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          // Log the error or handle it appropriately
          print('Failed to parse user data: $e');

          // Set the fields to their default values
          firstname.value = '';
          lastname.value = '';
          bio.value = '';
          description.value = '';
          dob.value = '';
          pincode.value = '';
          occupation.value = '';
          qualification.value = '';
          country.value = '';
          state.value = '';
          gender.value = '';
          photoStatusApproval.value ='';
          descStatusApproval.value ='';
          city.value = '';
          profilePhotoURL.value = '';
          coverPhotoURL.value = '';
          activeCity.value = '';
          dobController.text = '';
          apiService.isLoading.value = false;
        }

        update();
      }
      else if(
      response['status'] == 2 &&
          response['message'].contains('Organization Already Created.')
      ){
        Get.snackbar('Error', 'Organization Already Created.');
      }else {
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
  log('Network Error Please check your internet connection and try again!');
    } on HttpException {
      log('Http Error Could not find the service you were looking for!');
    } on FormatException {
      log('Error Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
     /* Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');

      */
      print('Unexpected error: $e');
    }
  }

  Future<void> getAllCities() async {
    try {
      final response = await http.get(
        Uri.parse(API.individualCities),
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> cityListJson =
        json.decode(response.body)['data'] as List;
        allCityList.value =
            cityListJson.map((city) => IndividualCity.fromJson(city)).toList();
            activeCities.add('Select Active city');
        allCityList.forEach((element) {
          activeCities.add(element.name);
        });
        log("cities $cityListJson");
        update();
      } else {
        throw Exception("Error with the request: ${response.statusCode}");
      }
    } on SocketException {
      log('Socket Exception No Internet connection Please check your internet connection and try again.');
    } on HttpException {
      log('HttpException Something went wrong Couldn\'t find the post.');
    } on FormatException {
      log('Format Exception Something went wrong Bad response format');
    }
  }

  @override
  void onClose() {
    activeCities.clear();
    //activeCity="".obs;
    super.onClose();
  }
}
