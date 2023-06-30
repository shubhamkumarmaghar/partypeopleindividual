import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/centralize_api.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

import '../models/city.dart';

class IndividualDashboardController extends GetxController {
  var buttonState = true;
  RxList<IndividualCity> allCityList = RxList();
  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());

  APIService apiService = Get.find();
  dynamic jsonPartyOgranisationDataToday = {}.obs;

  dynamic jsonPartyOgranisationDataTomm = {}.obs;

  dynamic jsonPartyPopularData = {}.obs;

  dynamic jsonPartyOgranisationDataUpcomming =
      {}.obs; // an observable isLoading state

  RxInt lengthOfTodayParties = 0.obs;
  RxInt lengthOfTommParties = 0.obs;
  RxInt lengthOfUpcomingParties = 0.obs;

  void switchButtonState() {
    if (buttonState == true) {
      buttonState = false;
    } else {
      buttonState = true;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllCities();
    individualProfileController.individualProfileData();
    getAllNearbyPeoples();
    getPartyByDate();
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
        update();
      } else {
        throw Exception("Error with the request: ${response.statusCode}");
      }
    } on SocketException {
      Get.snackbar('No Internet connection',
          'Please check your internet connection and try again.',
          snackPosition: SnackPosition.BOTTOM);
    } on HttpException {
      Get.snackbar('Something went wrong', 'Couldn\'t find the post.',
          snackPosition: SnackPosition.BOTTOM);
    } on FormatException {
      Get.snackbar('Something went wrong', 'Bad response format.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getAllNearbyPeoples() async {
    try {
      apiService.isLoading.value = true;
      var response = await apiService.individualNearbyPeoples(
          '${GetStorage().read('token')}', {'city_id': 'Ghazni'});
      print(response);

      if (response['status'] == 1 &&
          response['message'].contains('Data Found')) {
        try {
          print("Got the nearby Data => ${response}");
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          // Log the error or handle it appropriately
          print('Failed to parse user data: $e');

          apiService.isLoading.value = false;
        }

        update();
      } else {
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

  ///GET ALL PARTEIS - DELHI
  Future<void> getPartyByDate() async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '0', 'city': 'delhi', 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );
      dynamic decodedData = jsonDecode(response.body);
      print(decodedData);

      // Initialize lists to store parties
      List<dynamic> todayParties = [];
      List<dynamic> tomorrowParties = [];
      List<dynamic> upcomingParties = [];

      // Get current date
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = today.add(Duration(days: 1));

      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        allParties.sort((a, b) {
          DateTime startDateA = DateTime.parse(a['start_date']);
          DateTime startDateB = DateTime.parse(b['start_date']);
          return startDateA.compareTo(startDateB);
        });
        for (var party in allParties) {
          DateTime startDate = DateTime.parse(party['start_date']);
          print(party['papular_status']);
          if (startDate.isAtSameMomentAs(today)) {
            todayParties.add(party);
          } else if (startDate.isAtSameMomentAs(tomorrow)) {
            tomorrowParties.add(party);
          } else if (startDate.isAfter(tomorrow)) {
            upcomingParties.add(party);
          }
        }
      }

      // Print the parties in each list
      print('Today parties:');
      print(todayParties.length);

      print('Tomorrow parties:');
      print(tomorrowParties.length);

      print('Upcoming parties:');
      print(upcomingParties.length);

      jsonPartyOgranisationDataToday = todayParties;
      lengthOfTodayParties.value = todayParties.length;
      jsonPartyOgranisationDataTomm = tomorrowParties;
      lengthOfTommParties.value = tomorrowParties.length;
      jsonPartyOgranisationDataUpcomming = upcomingParties;
      lengthOfUpcomingParties.value = upcomingParties.length;

      await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/order/update_ragular_papular_status'),
      );

      update();
    } catch (e) {
      print("Exception at getPartyByDate => $e");
    }
  }
}
