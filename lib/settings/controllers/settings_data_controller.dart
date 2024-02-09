import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../centralize_api.dart';
import '../../login/views/login_screen.dart';

class SettingDataController extends GetxController{

void onInit(){
  super.onInit();

}

  Future<void> updateOnlineStatus(status) async {
    // API endpoint URL
    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'online_status': status == true ? "on" : "off",
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(API.updateOnlineStatus),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('status successfullu updated');
      } else {
        // Request failed
        print(
            'Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while updating status: $e');
    }
  }

  Future<void> updatePrivacyStatus(status) async {

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'privacy_online_status': status == true ? "No" : "Yes",
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(API.updatePrivacyOnlineStatus),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('status successfully updated');
      } else {
        // Request failed
        print(
            'Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while updating status: $e');
    }
  }


  Future<void> updateNotificationStatus(status) async {

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'notification_status': status == true ? "on" : "off",
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(API.updateNotificationStatus),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Notification status successfully updated');
      } else {
        // Request failed
        print(
            'Failed to update Notification status. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while updating Notification status: $e');
    }
  }

  Future<void> deleteAccount() async {
    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body not required

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(API.deleteMyAccount),
        headers: headers,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Account Successfully Deleted');
        GetStorage().remove('token');
        GetStorage().remove('loggedIn');
        GetStorage().remove('online_status');
        GetStorage().remove('online_notification_status');

        Get.offAll(const LoginScreen());
      } else {
        // Request failed
        print(
            'Failed to Delete account. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while deleting account: $e');
    }
  }

}