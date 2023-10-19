import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/login/views/login_screen.dart';
import 'package:partypeopleindividual/otp/model/otp_model.dart';

import 'centralize_api.dart';
import 'constants.dart';
import 'login/model/user_model.dart';

class APIService extends GetxController {
  RxBool isLoading = false.obs; // Add

  ///This method is used to send otp
  Future<User> login(String username, String phone, String deviceToken) async {
    try {
      final response = await _post(API.login,
          {'phone': phone,
            'username': username,
            'user_type':'Individual',
            'device_token': deviceToken,

          });

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
  Future<OTPVerificationResponse?> verifyOTP(String otp, String header) async {
    try {
      final response = await _post(API.otp, {
        'otp': otp,
        'user_type':'Individual'
      }, headers: {
        'x-access-token': header
      });

      if (response['status'] == 1) {
        // Login successful, return user data
        if(response['message'] != 'Sorry ! you can not login here') {
          final otpVerificationResponse = response;
          return OTPVerificationResponse.fromJson(otpVerificationResponse);
        }
        else{
          Get.snackbar(loginFailedTitle, organizationUser);
          Get.offAll(LoginScreen());
          return null;
        }
      }


        else {
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
  Future individualNearbyPeoples(Map<String, String> cityid ,header) async {
    final response = await _post(API.individualPeoplesNearby, cityid,
        headers: {'x-access-token': header});
    return response;
  }

/// do block/unblock people
  Future<void> doBlockUnblockPeople(String id,String status) async {
    try {
      http.Response response = await http.post(
          Uri.parse(API.blockUnblockApi),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          },
          body: {
            'block_user_id': id,
            'status' : status
          });

      print("response of unblock data ${response.body}");

      if (jsonDecode(response.body)['status'] == 1 && jsonDecode(response.body)['message'] == 'User block successfully') {
        print("User blocked successfully");
        Get.snackbar('Blocked' , 'You have successfully block ',);
      }
      else if(jsonDecode(response.body)['status'] == 1 && jsonDecode(response.body)['message'] == "User already block successfully"){
        print("User already block successfully");
        Get.snackbar('Blocked' , 'User already block successfully',);
      }
      else if(jsonDecode(response.body)['status'] == 1 && jsonDecode(response.body)['message'] == "User unblock successfully"){
        print("User unblocked successfully");
        Get.snackbar('Unblocked' , 'You have successfully Unblock ',);
      }
      else {
        print("User Unblocked failed ${response.body}");
        Get.snackbar('Opps!!!' , 'Process failed ',);
      }
    } on Exception catch (e) {
      print('Exception in blocked data ${e}');
    }
    update();
  }

  /// delete chat  people
  Future<void> deleteChatPeople(String id,Function onDelete) async {
    try {
      http.Response response = await http.post(
          Uri.parse(API.deleteChatPeopleApi),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          },
          body: {
            'individual_user_id': id,
          });

      print("response of delete data ${response.body}");

      if (jsonDecode(response.body)['status'] == 1 ) {
        onDelete();
        print("User blocked successfully");
        Get.snackbar('Deleted' , 'You have successfully Deleted person ',);
      }
      else {
        print("people from chatList delete failed ${response.body}");
        Get.snackbar('Opps!!!' , 'Process failed ',);
      }
    } on Exception catch (e) {
      print('Exception in chatList  delete data ${e}');
    }
  }


/// on going parties
  static Future<bool> ongoingParty(String id) async {
    final response = await http.post(
      Uri.parse(API.ongoingParty),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'party_id': id,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1) {
        print('Party ongoing save successfully');
        Get.snackbar('Welcome',
            'You are welcome to join party');
        return true;
      }
      else {
        print('Failed to update ongoing Party data');
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update Party onging data');
    }
  }


  /// all indiviusal people like
  static Future<int> likePeople(String id , bool status) async {
    final response = await http.post(
      Uri.parse(API.userLike),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },

      body: <String, String>{
        'user_like_status': status==true?"yes":"No",
        'user_like_id': id
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('User liked successfully')) {
        print('User like save successfully');
        return 1;

      }
      else if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('User unliked successfully')) {
        print('User unlike successfully');
        return 0;

      }
      else {
        print('else  Failed to like/ unlike ');
        return 0;
        //isLiked= false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to like/unlike');

    }
  }

  static Future<void> lastMessage(String id , String message,  String time , int chatCount) async {
    DateTime dateTime =  DateTime.fromMillisecondsSinceEpoch(int.parse(time) );
log('#   $chatCount');
    String time1 = dateTime.toString();
    print('bhhb'+time1);
    // log('${time1}');
    final response = await http.post(
      Uri.parse(API.updateChatMsg),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },

      body: <String, String>{
        'individual_user_id': id,
        'message': message,
        'datetime' :time1,
        if(chatCount != 0) 'message_count' : chatCount.toString(),
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('Last message update successfully')) {
        print('last message save successfully');

      }
      else {
        print('else  Failed to update message successfully ');

        //isLiked= false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update message successfully ');

    }
  }

   Future<String> updateActiveCity(String orgId , String activeCity) async {
    final response = await http.post(
      Uri.parse(API.updateActiveCity),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },

      body: <String, String>{
        'active_city': activeCity,
        'organization_id': orgId
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('User city update successfully')) {
        print('active city updated successfully');
        return '1';

      }
      else {
        print('else  Failed to active city updated  ');
        return '0';

      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update active city ');

    }
  }

  Future<String> uploadImage({ File? imgFile ,required String type, required String id,required String imageKey}) async {
    String url='';
    try {
      var headers = {'x-access-token': '${GetStorage().read('token')}'};
      // var dio = Dio();
      //
      // final hhh =await http.MultipartFile.fromPath('image_b',imgFile?.path ??File('').path,);
      // log('dd ${ hhh.filename},${hhh.field}');
      // var formData = FormData.fromMap({
      //   'image_b':hhh,
      //   'type': type,
      //   'party_id': 232.toString(),
      //
      // });
      // var responseDio = await dio.post(
      //     API.addImage,
      //     data: formData,
      //   options: Options(headers: headers)
      // );
      // log('xxxxxx $responseDio');
      var request = http.MultipartRequest('POST',
        Uri.parse(API.addImage),);

      request.fields.addAll({
        'type': type,
        'organization_id':id.toString(),

      });

      final data = await http.MultipartFile.fromPath(imageKey,imgFile?.path??File('').path,);
      log('ddddd ${data.contentType} - ${data.field} - ${data.filename}');
      request.files.addAll([data]);

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var response1 = await http.Response.fromStream(response);
      if (response1.statusCode == 200) {
        var parsed = jsonDecode(response1.body);
        log('$parsed');
        log('${response}  -- ${response1}  -- ${parsed['url']}');
        url= '${parsed['url']}';
        //var jsonResponse = await response.stream.bytesToString();

        //  log("response :: $jsonResponse " );

      }
    }
    catch(e){
      log("Error  "+ '${e}');
    }
    return url;
  }
}
