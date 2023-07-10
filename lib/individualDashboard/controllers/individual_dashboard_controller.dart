import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/centralize_api.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

import '../models/city.dart';
import '../models/party_model.dart';
import '../models/usermodel.dart';

class IndividualDashboardController extends GetxController {
  var buttonState = true;
  RxList<IndividualCity> allCityList = RxList();
  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());

  APIService apiService = Get.find();
  RxList<Party> jsonPartyOrganisationDataToday = <Party>[].obs;
  RxList<Party> jsonPartyOrganisationDataTomm = <Party>[].obs;
  RxList<Party> jsonPartyOgranisationDataUpcomming = <Party>[].obs;

  RxList<Party> jsonPartyPopularData = <Party>[].obs;

// an observable isLoading state

  RxList<Party> wishlistedParties = RxList<Party>([]);

  RxInt lengthOfTodayParties = 0.obs;
  RxInt lengthOfTommParties = 0.obs;
  RxInt lengthOfUpcomingParties = 0.obs;

  RxList<UserModel> usersList = RxList<UserModel>();

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

  var noUserFoundController = null;

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
        '${GetStorage().read('token')}',
      );
      print("Nearby People");
      print(response.body);
      if (response['status'] == 1 && response['message'].contains('Success')) {
        try {
          print("Nearby People");
          print(response.body);
          var usersData = response['data'] as List;
          usersList.addAll(usersData.map((user) => UserModel.fromJson(user)));
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          print("test Complete");

          noUserFoundController.text = 'No User';
          apiService.isLoading.value = false;
        }
      } else if (response['message'].contains('Not')) {
        print("test Complete");
        // Store the response message in the controller if user not found
        noUserFoundController.text = response['message'];
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
      print("test Complete");

      noUserFoundController.text = 'No User';
      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
    } on HttpException {
      print("test Complete");

      noUserFoundController.text = 'No User';
      Get.snackbar('Error', 'Could not find the service you were looking for!');
    } on FormatException {
      print("test Complete");

      noUserFoundController.text = 'No User';
      Get.snackbar('Error', 'Bad response format. Please contact support!');
    } catch (e) {
      print("test Complete");

      noUserFoundController = 'No User';
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
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

      // Initialize lists to store parties
      List<Party> todayParties = [];
      List<Party> tomorrowParties = [];
      List<Party> upcomingParties = [];

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
          Party parsedParty = Party.fromJson(party);
          DateTime startDate = DateTime.parse(parsedParty.startDate);
          if (startDate.isAtSameMomentAs(today)) {
            print('Today Parties');
            print(parsedParty);
            todayParties.add(parsedParty);
          } else if (startDate.isAtSameMomentAs(tomorrow)) {
            tomorrowParties.add(parsedParty);
          } else if (startDate.isAfter(tomorrow)) {
            upcomingParties.add(parsedParty);
          }
        }
      }

      // Print the parties in each list

      ///setting length
      lengthOfTodayParties.value = todayParties.length;
      lengthOfTommParties.value = tomorrowParties.length;
      lengthOfUpcomingParties.value = upcomingParties.length;

      ///setting number of party
      jsonPartyOrganisationDataToday.value = todayParties;
      jsonPartyOrganisationDataTomm.value = tomorrowParties;
      jsonPartyOgranisationDataUpcomming.value = upcomingParties;
      update();
    } catch (e) {}
  }
}
