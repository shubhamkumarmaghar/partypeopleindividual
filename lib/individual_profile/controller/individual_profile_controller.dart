import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/api_helper_service.dart';

import '../../widgets/submit_application.dart';

class IndividualProfileController extends GetxController {
  RxString coverPhotoURL = ''.obs;
  RxString profilePhotoURL = ''.obs;
  RxString username = ''.obs;
  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
  RxString bio = ''.obs;
  RxString dob = ''.obs;
  RxString pincode = ''.obs;
  RxString organization_id = ''.obs;
  RxString occupation = ''.obs;
  RxString qualification = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString gender = ''.obs;
  RxString city = ''.obs;
  TextEditingController dobController = TextEditingController();
  RxList selectedAmenities = [].obs;
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

    if (lastname.value.isEmpty) {
      Get.snackbar('Name Error', 'Last name should not be empty');
      return;
    }

    if (bio.value.isEmpty) {
      Get.snackbar('Bio Error', 'Bio should not be empty');
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
        'bio': bio.value.toString(),
        'dob': dob.value.toString(),
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

    if (bio.value.isEmpty) {
      Get.snackbar('Bio Error', 'Bio should not be empty');
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
        'bio': bio.value.toString(),
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
      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
    } on HttpException {
      Get.snackbar('Error', 'Could not find the service you were looking for!');
    } on FormatException {
      Get.snackbar('Error', 'Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
      print('Unexpected error: $e');
    }
  }

  Future<void> individualProfileUpdate() async {
    print('Individual Profile Update :=> ${userData}');
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
      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
    } on HttpException {
      Get.snackbar('Error', 'Could not find the service you were looking for!');
    } on FormatException {
      Get.snackbar('Error', 'Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
      print('Unexpected error: $e');
    }
  }

  Future<void> individualProfileData() async {
    try {
      apiService.isLoading.value = true;
      var response = await apiService
          .individualProfileData('${GetStorage().read('token')}');
      print(response);

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
          dob.value = user['dob'] ?? '';
          pincode.value = user['pincode'] ?? '';
          occupation.value = user['occupation'] ?? '';
          qualification.value = user['qualification'] ?? '';
          country.value = user['country'] ?? '';
          state.value = user['state'] ?? '';
          username.value = response['user_name'];
          gender.value = user['gender'] ?? '';
          getPrefiledData = user?['org_amenitie_id']?.split(',');
          print("indi amen :=> ${getPrefiledData}");
          city.value = user['city'] ?? '';
          profilePhotoURL.value = user['profile_pic'] ?? '';
          coverPhotoURL.value = user['cover_photo'] ?? '';
          organization_id.value = user['id'] ?? "";
          // Set dobController's text to the 'dob' value
          dobController.text = dob.value;
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          // Log the error or handle it appropriately
          print('Failed to parse user data: $e');

          // Set the fields to their default values
          firstname.value = '';
          lastname.value = '';
          bio.value = '';
          dob.value = '';
          pincode.value = '';
          occupation.value = '';
          qualification.value = '';
          country.value = '';
          state.value = '';
          gender.value = '';
          city.value = '';
          profilePhotoURL.value = '';
          coverPhotoURL.value = '';

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
      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
    } on HttpException {
      Get.snackbar('Error', 'Could not find the service you were looking for!');
    } on FormatException {
      Get.snackbar('Error', 'Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
      print('Unexpected error: $e');
    }
  }
}
