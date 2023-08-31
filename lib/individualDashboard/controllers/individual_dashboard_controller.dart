import 'dart:async';
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
  RxString approvalStatus = '${GetStorage().read('approval_status')}'.obs;
  RxString newUser = '${GetStorage().read('newUser')}'.obs;
  RxString plan = '${GetStorage().read('plan_plan_expiry')}'.obs;

  APIService apiService = Get.find();
  RxList<Party> jsonPartyOrganisationDataToday = <Party>[].obs;
  RxList<Party> jsonPartyOrganisationDataTomm = <Party>[].obs;
  RxList<Party> jsonPartyOgranisationDataUpcomming = <Party>[].obs;
  RxList<Party> jsonPartyPopularData = <Party>[].obs;
  RxBool showAnimatedHeart=false.obs;

  void animateHeart()async{
    showAnimatedHeart = true.obs;
    log('sdksj');
    await Future.delayed(Duration(seconds: 5));
    showAnimatedHeart=false.obs;
    update();
  }

// an observable isLoading state

  RxList<Party> wishlistedParties = RxList<Party>([]);

  RxInt lengthOfTodayParties = 0.obs;
  RxInt lengthOfTommParties = 0.obs;
  RxInt lengthOfUpcomingParties = 0.obs;
  RxInt lengthOfPopularParties = 0.obs;
  RxInt onlineStatus = 0.obs;
  RxString chatCount = ''.obs;
  RxString notificationCount = ''.obs;
  RxString partyCity = ''.obs;

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

    getDataForDashboard();

    Timer.periodic(Duration(seconds: 5), (timer) {
      getOnlineStatus();
      //getDataForDashboard();
    });
  }
  void getDataForDashboard() async {

    lengthOfTodayParties = 0.obs;
    lengthOfTommParties = 0.obs;
    lengthOfUpcomingParties = 0.obs;
    lengthOfPopularParties = 0.obs;
    onlineStatus = 0.obs;
    usersList= RxList<UserModel>();
    wishlistedParties = RxList<Party>([]);
    jsonPartyOrganisationDataToday = <Party>[].obs;
    jsonPartyOrganisationDataTomm = <Party>[].obs;
    jsonPartyOgranisationDataUpcomming = <Party>[].obs;
    jsonPartyPopularData = <Party>[].obs;
    getAllCities();
    getOnlineStatus();
    await individualProfileController.individualProfileData();
    getAllNearbyPeoples();
    getPopularParty();
    getTodayPary();
    getTomarrowParty();
    getUpcomingParty();

    //getPartyByDate();

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
     //  individualProfileController.activeCities.add('Select Active city');
     //  allCityList.forEach((element) {
      //    individualProfileController.activeCities.add(element.name);
      //  });
       // log("cities $cityListJson");
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

  Future<void> getAllNearbyPeoples() async {
    String state = GetStorage().read('state');
    String city ='';
    if(individualProfileController.activeCity.value.toString().isNotEmpty)
      {
         city = individualProfileController.activeCity.value.toString();
        log("city for nearbypeople $city");
      }
    else{
      city ='delhi';
    }

    try {
      apiService.isLoading.value = true;
      var response = await apiService.individualNearbyPeoples(
        {
          'city_id': city.toLowerCase(),
          'state' : state.toLowerCase()
      },
        '${GetStorage().read('token')}',
      );
      print("Nearby People 2");

      if (response['status'] == 1 && response['message'].contains('Success')) {
        try {
          print("Nearby People 3");
         //print(response.body);
          var usersData = response['data'] as List;
          usersData.forEach((element) => log('Data :: $element'));
          usersList.addAll(usersData.map((user) => UserModel.fromJson(user)));
          log("length of people near by ${usersList.length}");
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          print("test Complete 0  $e  ");

          noUserFoundController.value = 'No User';
          apiService.isLoading.value = false;
        }
      }
      else if (response['status'] == 0 && response['message'].contains('Not')) {
        print("User Not Found");
        // Store the response message in the controller if user not found
        noUserFoundController.value = response['message'];
        update();

        Get.snackbar('Opps!', 'No User found ');
      }
      else {
        Get.snackbar('Opps!', 'No User found ');
      }
    } on SocketException {
      print("test Complete 1");

      log('Socket Exception Could not find the service you were looking for!');
      noUserFoundController.value = 'No User';
      update();

     /* Get.snackbar('Network Error',
          'Please check your internet connection and try again!');
      */
    } on HttpException {
      noUserFoundController.value = 'No User';
      update();

      log('Http Exception Could not find the service you were looking for!');
    } on FormatException {
      print("Format Exception : test Complete");

      noUserFoundController.value = 'No User';
      update();
      log("Format Exception: Something went wrong', 'Bad response format.");
     /* Get.snackbar('Error', 'Bad response format. Please contact support!');*/
    } catch (e) {
      print("test Complete $e");

      noUserFoundController.value = 'No User';
      update();
      // If the exact error type isn't matched in the preceding catch clauses
      log('Unexpected Error Something unexpected happened. Try again later!');
    /*  Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!'); */
    }
  }

  ///GET ALL PARTEIS - DELHI
  ///GET ALL PARTIES - DELHI
  Future<void> getPartyByDate() async {
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
       /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      String getcity = GetStorage().read('state') ?? 'delhi';
      if(partyCity.value == '')
        {
          partyCity.value = getcity;
          log('partycity ${partyCity.value}');
        }
      log('else partycity ${partyCity.value}');
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '0', 'city': partyCity.value, 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      // Fetch popular parties
      http.Response popularResponse = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '0', 'city': partyCity.value, 'filter_type': '1'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);
      dynamic popularDecodedData = jsonDecode(popularResponse.body);
      print("all parties $decodedData");
      print("all Popular parties $popularDecodedData");
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
            print( party);

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

        allPopularParties.sort((a, b) {
          DateTime startDateA = DateTime.fromMillisecondsSinceEpoch(
              int.parse(a['start_date']) * 1000);
          DateTime startDateB = DateTime.fromMillisecondsSinceEpoch(
              int.parse(b['start_date']) * 1000);
          return startDateA.compareTo(startDateB);
        });
        for (var party in allPopularParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            popularParties.add(parsedParty);
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


Future<void> getTodayPary() async{
  try {
    // Fetch all parties
    /// status': '1' current date parties
    /// status': '2' tomarrow date parties
    /// status': '3' tomarrow date parties
    ///
    /// 'filter_type': '2' == regular parties
    /// 'filter_type': '1' == popular parties
    if (individualProfileController.activeCity.value.isNotEmpty) {
      partyCity.value =individualProfileController.activeCity.value.toString();
      log('partycity ${partyCity.value}');
    }
    log('else partycity ${partyCity.value}');
    http.Response response = await http.post(
      Uri.parse(
          'https://app.partypeople.in/v1/party/get_all_individual_party'),
      body: {'status': '1', 'city': partyCity.value.toLowerCase(), 'filter_type': '2'},
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );

    dynamic decodedData = jsonDecode(response.body);

    print("all today parties $decodedData");


    List<Party> todayParties = [];


    // Loop through parties and sort them into appropriate lists
    if (decodedData['data'] != null) {
      List<dynamic> allParties = decodedData['data'];
      for (var party in allParties) {
        try {
          Party parsedParty = Party.fromJson(party);
          print( party);
            todayParties.add(parsedParty);

          ///setting length
          lengthOfTodayParties.value = todayParties.length;

          ///setting number of party
          jsonPartyOrganisationDataToday.value = todayParties;
          update();
        } catch (e) {
          print('Error parsing today party: $e');
        }
      }
      }
    }
  catch(e){
    print('Error fetching today parties: $e');
  }

}

Future<void> getTomarrowParty() async{
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty == '') {
        partyCity.value =individualProfileController.activeCity.value.toString();
        log('tomarrow partycity ${partyCity.value}');
      }
      log('else tomarrow partycity ${partyCity.value}');
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '2', 'city': partyCity.value.toLowerCase(), 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);

      print("all tomarrow parties $decodedData");


      List<Party> tomarrowParties = [];


      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            print( party);
            tomarrowParties.add(parsedParty);

            ///setting length
            lengthOfTommParties.value = tomarrowParties.length;

            ///setting number of party
            jsonPartyOrganisationDataTomm.value = tomarrowParties;
            update();
          } catch (e) {
            print('Error parsing today party: $e');
          }
        }
      }
    }
    catch(e){
      print('Error fetching today parties: $e');
    }

  }

  Future<void> getUpcomingParty() async{
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty) {
        partyCity.value = individualProfileController.activeCity.value.toString();
        log('upcoming partycity ${partyCity.value}');
      }
      log('else upcoming partycity ${partyCity.value}');
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '3', 'city': partyCity.value.toLowerCase(), 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);

      print("all upcoming parties $decodedData");


      List<Party> upcomingParties = [];


      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            print( party);
            upcomingParties.add(parsedParty);

            ///setting length
            lengthOfUpcomingParties.value = upcomingParties.length;

            ///setting number of party
            jsonPartyOgranisationDataUpcomming.value = upcomingParties;
            update();
          } catch (e) {
            print('Error parsing today party: $e');
          }
        }
      }
    }
    catch(e){
      print('Error fetching today parties: $e');
    }

  }

  Future<void> getPopularParty() async{
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.city.value.isNotEmpty) {
        partyCity.value = individualProfileController.activeCity.value.toString();
        log('upcoming partycity ${partyCity.value}');
      }
      log('else upcoming partycity ${partyCity.value}');
      http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/party/get_all_individual_party'),
        body: {'status': '5', 'city': partyCity.value.toLowerCase(), 'filter_type': '1'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);

      print("all popular parties $decodedData");


      List<Party> popularParties = [];

      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        List<dynamic> allParties = decodedData['data'];
        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            print( party);
            popularParties.add(parsedParty);

            ///setting length
            lengthOfPopularParties.value = popularParties.length;

            ///setting number of party
            jsonPartyPopularData.value = popularParties;
            update();
          } catch (e) {
            print('Error parsing today party: $e');
          }
        }
      }
    }
    catch(e){
      print('Error fetching today parties: $e');
    }

  }
  /// GET ONLINE STATUS


  Future<void> getOnlineStatus() async {
    try {

      // Get current date
      DateTime now = DateTime.now();
      log("current"+ now.toString());
      String onlineTime = now.add(Duration(minutes: 5)).toString();
      var  time = onlineTime.split('.');
      onlineTime = time[0];

      log("After adding few min "+ onlineTime.toString());
      final response = await http.post(
        Uri.parse(API.onlineStatus),
        body:{'online_time_expiry' : onlineTime},
        headers: {
          'x-access-token': '${GetStorage().read('token')}',

        },
      );

      if (response.statusCode == 200) {
       var decode = jsonDecode(response.body);
        if (decode['status'] == 1 ) {
          try {
            onlineStatus.value = decode['status'];
            log("online Status : $onlineStatus  ${decode['plan_plan_expiry']}");
            GetStorage().write('plan_plan_expiry', decode['plan_plan_expiry']);
            String approval_date =  decode['approval_date'];
            chatCount.value = decode['chat_count'];
            notificationCount.value = decode['notification_count']??'0';
            log('notification count ${notificationCount.value}');
            log('chatcount ${decode['chat_count']}');
            if(approval_date !='') {
              GetStorage().write('approval_status', '${decode['approval_status']}');
              approvalStatus.value = GetStorage().read('approval_status');
              log('approval status ${approvalStatus}');
              DateTime approvalTime = DateTime.parse(approval_date);
              DateTime newApproval_time = approvalTime.add(Duration(days: 2));
              if (newApproval_time.isAfter(DateTime.now())) {
                GetStorage().write('newUser', '1');
              }
              else{
                GetStorage().write('newUser', '0');
              }
              log('${approvalTime.toString()}');
            }
            else{
              log('approval statushvkkhb ${approvalStatus}');
              GetStorage().write('approval_status', '0');
              approvalStatus.value = GetStorage().read('approval_status');
            }
            apiService.isLoading.value = false;
            update();
          } catch (e) {
            print("error catch for online status   $e  ");
            apiService.isLoading.value = false;
          }
        }
        else {
          print("Opps!', 'online status failed ");

        }
        update();
      } else {
        throw Exception("Error with the request: ${response.statusCode}");
      }
    } on SocketException {

      log("Socket Exception: Something went wrong', 'Bad response format.");
     /* Get.snackbar('No Internet connection',
          'Please check your internet connection and try again.',
          snackPosition: SnackPosition.BOTTOM);*/
    } on HttpException {
      log("Http Exception: Something went wrong', 'Bad response format.");

     /* Get.snackbar('Something went wrong', 'Couldn\'t find the post.',
          snackPosition: SnackPosition.BOTTOM); */
    } on FormatException {
      log("Format Exception: Something went wrong', 'Bad response format.");
     /* Get.snackbar('Something went wrong', 'Bad response format.',
          snackPosition: SnackPosition.BOTTOM);
      */
    }
  }


}
