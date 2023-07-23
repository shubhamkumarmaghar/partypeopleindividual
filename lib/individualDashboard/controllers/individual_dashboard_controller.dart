import 'dart:convert';
import 'dart:developer';
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
  RxInt lengthOfPopularParties = 0.obs;

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
    getAllNearbyPeoples();
    getAllCities();
    individualProfileController.individualProfileData();
    getPartyByDate();
  }

  RxString noUserFoundController = "null".obs;

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
        log("cities $cityListJson");
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
    print('nearby user');
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

          noUserFoundController.value = 'No User';
          apiService.isLoading.value = false;
        }
      } else if (response['message'].contains('Not')) {
        print("test Complete");
        // Store the response message in the controller if user not found
        noUserFoundController.value = response['message'];
        update();

        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
      print("test Complete");

      noUserFoundController.value = 'No User';
      update();

      Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
    } on HttpException {
      print("test Complete");

      noUserFoundController.value = 'No User';
      update();

      Get.snackbar('Error', 'Could not find the service you were looking for!');
    } on FormatException {
      print("test Complete");

      noUserFoundController.value = 'No User';
      update();

      Get.snackbar('Error', 'Bad response format. Please contact support!');
    } catch (e) {
      print("test Complete");

      noUserFoundController.value = 'No User';
      update();
      // If the exact error type isn't matched in the preceding catch clauses
      Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');
    }
  }

  ///GET ALL PARTEIS - DELHI
  ///GET ALL PARTIES - DELHI
  Future<void> getPartyByDate() async {
    try {
      // Fetch all parties
      http.Response response = await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '0', 'city': 'delhi', 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      // Fetch popular parties
      http.Response popularResponse = await http.post(
        Uri.parse(
            'http://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '0', 'city': 'delhi', 'filter_type': '1'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);
      dynamic popularDecodedData = jsonDecode(popularResponse.body);
      print("all parties $decodedData");
      print("all Popular parties $decodedData");
      // Initialize lists to store parties
      List<Party> todayParties = [];
      List<Party> tomorrowParties = [];
      List<Party> upcomingParties = [];
      List<Party> popularParties = []; // List for popular parties

      // Get current date
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = today.add(const Duration(days: 1));

      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        allParties.sort((a, b) {
          DateTime startDateA = DateTime.fromMillisecondsSinceEpoch(
              int.parse(a['start_date']) * 1000);
          DateTime startDateB = DateTime.fromMillisecondsSinceEpoch(
              int.parse(b['start_date']) * 1000);
          return startDateA.compareTo(startDateB);
        });

        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(parsedParty.startDate) * 1000);
            print(party);

            // Extract the Date part only from startDate
            DateTime startDateDateOnly =
                DateTime(startDate.year, startDate.month, startDate.day);

            if (startDateDateOnly.isAtSameMomentAs(today)) {
              todayParties.add(parsedParty);
            } else if (startDateDateOnly.isAtSameMomentAs(tomorrow)) {
              tomorrowParties.add(parsedParty);
            } else if (startDateDateOnly.isAfter(tomorrow)) {
              upcomingParties.add(parsedParty);
            }
          } catch (e) {
            print('Error parsing party: $e');
          }
        }
      }

      // Loop through popular parties and add them to popularParties list
      if (popularDecodedData['data'] != null) {
        List<dynamic> allPopularParties = popularDecodedData['data'];
        for (var party in allPopularParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            popularParties.add(parsedParty);
          } catch (e) {
            print('Error parsing popular party: $e');
          }
        }
      }

      ///setting length
      lengthOfTodayParties.value = todayParties.length;
      lengthOfTommParties.value = tomorrowParties.length;
      lengthOfUpcomingParties.value = upcomingParties.length;
      lengthOfPopularParties.value =
          popularParties.length; // Set popular parties length

      ///setting number of party
      jsonPartyOrganisationDataToday.value = todayParties;
      jsonPartyOrganisationDataTomm.value = tomorrowParties;
      jsonPartyOgranisationDataUpcomming.value = upcomingParties;
      jsonPartyPopularData.value = popularParties; // Set popular parties

      update();
    } catch (e) {
      print('Error fetching parties: $e');
    }
  }
}
