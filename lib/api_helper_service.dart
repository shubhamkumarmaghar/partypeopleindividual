import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/otp/model/otp_model.dart';

import 'centralize_api.dart';
import 'login/model/user_model.dart';

class APIService extends GetxController {
  RxBool isLoading = false.obs; // Add

  ///This method is used to send otp
  Future<User> login(String username, String phone, String deviceToken) async {
    try {
      final response = await _post(API.login,
          {'phone': phone, 'username': username, 'device_token': deviceToken});

      if (response['status'] == 1) {
        // Login successful, return user data
        final userData = response['data'] as Map<String, dynamic>;
        return User.fromJson(userData);
      } else {
        // Handle failure
        throw Exception(response['message']);
      }
    } catch (e) {
      // Using Get.snackbar
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  ///This method is used to verify otp
  Future<OTPVerificationResponse> verifyOTP(String otp, String header) async {
    try {
      final response = await _post(API.otp, {
        'otp': otp,
      }, headers: {
        'x-access-token': header
      });

      if (response['status'] == 1) {
        // Login successful, return user data
        final otpVerificationResponse = response;
        return OTPVerificationResponse.fromJson(otpVerificationResponse);
      } else {
        // Handle failure
        throw Exception(response['message']);
      }
    } catch (e) {
      // Using Get.snackbar
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  ///Update User Type
  updateUserType(String userType, String header) async {
    try {
      final response = await _post(API.updateType, {
        'user_type': userType,
      }, headers: {
        'x-access-token': header
      });

      if (response['status'] == 1) {
        // Login successful, return user data
        final userTypeResponse = response;
        print(userTypeResponse);
      } else {
        // Handle failure
        throw Exception(response['message']);
      }
    } catch (e) {
      // Using Get.snackbar
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _post(
      String endpoint, Map<String, dynamic>? data,
      {Map<String, String>? headers}) async {
    try {
      isLoading.value = true; // Show loading indicator

      final encodedData = data;

      if (kDebugMode) {
        print('Endpoint: $endpoint');
        print('Headers: $headers');
        print('Body: $encodedData');
      }

      final http.Response response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: encodedData,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load API endpoint: $endpoint');
        throw Exception('Failed to load API endpoint: $endpoint');
      }
    } on SocketException {
      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
      throw Exception('Network Error');
    } on HttpException {
      Get.snackbar('Error', 'Could not find the service you were looking for!');
      throw Exception('HTTP Exception');
    } on FormatException {
      Get.snackbar('Error', 'Bad response format. Please contact support!');
      throw Exception('Format Exception');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  ///This method is used to Create Individual Profile
  Future individualProfileCreation(Map<String, String> userData, header) async {
    final response = await _post(API.individualProfileCreation, userData,
        headers: {'x-access-token': header});

    return response;
  }

  ///This method is used to update Individual Profile
  Future individualProfileUpdate(Map<String, String> userData, header) async {
    final response = await _post(API.individualProfileUpdate, userData,
        headers: {'x-access-token': header});

    return response;
  }

  ///Get all data for individual profile
  Future individualProfileData(header) async {
    final response = await _post(API.individualProfileData, null,
        headers: {'x-access-token': header});

    return response;
  }

  ///Get All Nearby Peoples
  Future individualNearbyPeoples(header) async {
    final response = await _post(API.individualPeoplesNearby, null,
        headers: {'x-access-token': header});

    return response;
  }
}
