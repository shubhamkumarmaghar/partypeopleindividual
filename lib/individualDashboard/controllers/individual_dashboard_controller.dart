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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/city.dart';
import '../models/party_model.dart';
import '../models/usermodel.dart';

class IndividualDashboardController extends GetxController {
  int pageTomarrowCount = 1;
  int pageTomarrowCountresponse = 1;
  int startTomarrow = 0;
  int pageTodayCount = 1;
  int pageTodayCountresponse = 1;
  int startToday = 0;
  int pageUpcominmgCount = 1;
  int pageUpcomingCountresponse = 1;
  int startUpcoming = 0;
  int pagePopularCount = 1;
  int pagePopularCountresponse = 1;
  int startPopular = 0;
  var buttonState = true;
  RxBool nearbyvalue = true.obs;
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
  RxList<UserModel> usersList = <UserModel>[].obs;
  RxList<Party> wishlistedParties = <Party>[].obs;
  RxBool showAnimatedHeart = false.obs;
  final refreshController = RefreshController(initialRefresh: false);
  final refreshTomarrowController = RefreshController(initialRefresh: false);
  final refreshTodayController = RefreshController(initialRefresh: false);
  final refreshUpcomingController = RefreshController(initialRefresh: false);
  final refreshPopluarController = RefreshController(initialRefresh: false);

  void animateHeart() async {
    showAnimatedHeart = true.obs;
    await Future.delayed(Duration(seconds: 5));
    showAnimatedHeart = false.obs;
    update();
  }

// an observable isLoading state



  RxInt lengthOfTodayParties = 0.obs;
  RxInt lengthOfTommParties = 0.obs;
  RxInt lengthOfUpcomingParties = 0.obs;
  RxInt lengthOfPopularParties = 0.obs;
  RxInt onlineStatus = 0.obs;
  RxString chatCount = ''.obs;
  RxString notificationCount = ''.obs;
  RxString partyCity = ''.obs;



  void switchButtonState() {
    if (buttonState == true) {
      buttonState = false;
    } else {
      buttonState = true;
    }
  }

  late Timer timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDataForDashboard(false);

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getOnlineStatus();
      //getDataForDashboard(true);
    });
  }

  void getDataForDashboard(bool isRefresh) async {
    log('token :::${GetStorage().read('token')}');
    lengthOfTodayParties = 0.obs;
    lengthOfTommParties = 0.obs;
    lengthOfUpcomingParties = 0.obs;
    lengthOfPopularParties = 0.obs;
    onlineStatus = 0.obs;
    usersList = <UserModel>[].obs;
    wishlistedParties = <Party>[].obs;
    jsonPartyOrganisationDataToday = <Party>[].obs;
    jsonPartyOrganisationDataTomm = <Party>[].obs;
    jsonPartyOgranisationDataUpcomming = <Party>[].obs;
    jsonPartyPopularData = <Party>[].obs;
    getAllCities();
    getOnlineStatus();
    await individualProfileController.individualProfileData();
    String type = '';
    if (isRefresh == true) {
      getAllNearbyPeoples(type: nearbyvalue.value == true ? '2' : '1');
    } else {
      type = individualProfileController.gender.value.toString() == 'Male'
          ? '2'
          : '1';
      getAllNearbyPeoples(type: type);
    }

    getPopularParty(isloading: false);
    getTodayParty(isloading: false);
    getTomarrowParty(isloading: false);
    getUpcomingParty(isloading: false);

    //getPartyByDate();
  }

  RxString noUserFoundController = "".obs;

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

  Future<void> getAllNearbyPeoples({String type = '0'}) async {
   // String state = GetStorage().read('state') ?? 'delhi';
    String city = '';
    if (individualProfileController.activeCity.value.toString().isNotEmpty) {
      city = individualProfileController.activeCity.value.toString();
    } else {
      city = 'delhi';
    }
    try {
    //  apiService.isLoading.value = true;
      var response = await apiService.individualNearbyPeoples(
        {
          'city_id': city.toLowerCase(),
          //'state': state.toLowerCase(),
          'start': '1',
          'end': '15',
          if (type == '1') 'gender': 'male',
          if (type == '2') 'gender': 'female',
        },
        '${GetStorage().read('token')}',
      );

      if (response['status'] == 1 && response['message'].contains('Success')) {
        var usersData = response['data'] as List;
        usersData.forEach((element) => log('Data :: $element'));
        usersList.addAll(usersData.map((user) => UserModel.fromJson(user)));

     //   apiService.isLoading.value = false;
        update();
      } else if (response['status'] == 0 &&
          response['message'].contains('Not')) {
        noUserFoundController.value = '';
        update();
        Get.snackbar('Oops!', 'No User found ');
      } else {
        Get.snackbar('Oops!', 'No User found ');
      }
    } catch (e) {
      noUserFoundController.value = '';
   //   apiService.isLoading.value = false;
      update();
    }
    update();
  }

/*
  Future<void> getPaginatedNearbyPeoples({required bool isRefresh}) async {
    String state = GetStorage().read('state');
    String city = '';
    if (individualProfileController.activeCity.value.toString().isNotEmpty) {
      city = individualProfileController.activeCity.value.toString();
    } else {
      city = 'delhi';
    }
   if(isRefresh){
     start = 1;
     end = 15;
     paginatedUsersList.clear();
   }else {
     start = start + end;
     end = end + 15;
   }
    try {
      var response = await apiService.individualNearbyPeoples(
        {
          'city_id': city.toLowerCase(),
          'state': state.toLowerCase(),
          'start':start.toString(),
          'end':end.toString()
        },
        '${GetStorage().read('token')}',
      );

      if (response['status'] == 1 && response['message'].contains('Success')) {
        var usersData = response['data'] as List;

        paginatedUsersList.addAll(usersData.map((user) => UserModel.fromJson(user)));

        if(usersData.isEmpty){
          start = start-15;
          end = end-15;
        }
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        update();
      } else if (response['status'] == 0 &&
          response['message'].contains('Not')) {
        noUserFoundPaginationController.value = response['message'];
        start = start-15;
        end = end-15;
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        update();

        Get.snackbar('Opps!', 'No User found ');
      } else {
        start = start-15;
        end = end-15;
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        Get.snackbar('Opps!', 'No User found ');
      }
    } catch (e) {
      noUserFoundPaginationController.value = 'No User';
      start = start-15;
      end = end-15;
      if(isRefresh){
        refreshController.refreshCompleted();
      }else{
        refreshController.loadComplete();
      }
      update();
    }
  }
*/

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
      if (partyCity.value == '') {
        partyCity.value = getcity;
        log('partycity ${partyCity.value}');
      }
      log('else partycity ${partyCity.value}');
      http.Response response = await http.post(
        Uri.parse(API.getAllIndividualParty),
        body: {'status': '0', 'city': partyCity.value, 'filter_type': '2'},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      // Fetch popular parties
      http.Response popularResponse = await http.post(
        Uri.parse(API.getAllIndividualParty),
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

  Future<void> getTodayParty({required bool isloading}) async {
    try {
      var totalParties;
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty) {
        partyCity.value =
            individualProfileController.activeCity.value.toString();
        log('partycity ${partyCity.value}');
      }
      log('else partycity ${partyCity.value}');
      if (!isloading) {
        pageTodayCount = 1;
        pageTodayCountresponse = 1;
        startToday = pageTodayCount;
        jsonPartyOrganisationDataToday.clear();
        // paginatedUsersList.clear();
      } else {
        startToday = pageTodayCount;
        // start =  ++end;
        //  end = end + 15;
      }
      if (pageTodayCount <= pageTodayCountresponse) {
      http.Response response = await http.post(
        Uri.parse(API.getAllIndividualParty),
        body: {
          'status': '1',
          'city': partyCity.value.toLowerCase(),
          'filter_type': '2',
          'page_number': pageTodayCount.toString(),
        },
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);

      print("all today parties $decodedData");

      List<Party> todayParties = [];
      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        if (pageTodayCount == 1) {
          pageTodayCountresponse = decodedData['total_pages'];
          totalParties = decodedData['total_recrods'];
          log('page count ::: $pageTodayCountresponse');
          pageTodayCount++;
        } else {
          pageTodayCount++;
        }
        List<dynamic> allParties = decodedData['data'];
        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            print(party);
            todayParties.add(parsedParty);

          } catch (e) {
            if (!isloading) {
              refreshTodayController.refreshCompleted();
            } else {
              refreshTodayController.loadComplete();
            }
            print('Error parsing today party: $e');
          }
        }
        ///setting length
       // lengthOfTodayParties.value = todayParties.length;
       lengthOfTodayParties.value = decodedData['total_recrods'];

        ///setting number of party
        jsonPartyOrganisationDataToday.addAll(todayParties);
        if (!isloading) {
          refreshTodayController.refreshCompleted();
        } else {
          refreshTodayController.loadComplete();
        }
        update();
      }
    }
      else{
        if (!isloading) {
          refreshTodayController.refreshCompleted();
        } else {
          refreshTodayController.loadComplete();
        }
        Get.snackbar('Oops!', 'No More Party found ');
      }
      }
      catch (e) {
      if (!isloading) {
        refreshTodayController.refreshCompleted();
      } else {
        refreshTodayController.loadComplete();
      }
      print('Error fetching today parties: $e');
    }
  }

  Future<void> getTomarrowParty({required bool isloading}) async {
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty == '') {
        partyCity.value =
            individualProfileController.activeCity.value.toString();
        log('tomarrow partycity ${partyCity.value}');
      }
      log('else tomarrow partycity ${partyCity.value}');
      if (!isloading) {
        pageTomarrowCount = 1;
        pageTomarrowCountresponse = 1;
        startTomarrow = pageTomarrowCount;
        jsonPartyOrganisationDataTomm.clear();
        // paginatedUsersList.clear();
      } else {
        startTomarrow = pageTomarrowCount;
      }

     if (pageTomarrowCount <= pageTomarrowCountresponse) {

        http.Response response = await http.post(
          Uri.parse(API.getAllIndividualParty),
          body: {
            'status': '2',
            'city': partyCity.value.toLowerCase(),
            'filter_type': '2',
            'page_number': pageTomarrowCount.toString(),
          },
          headers: {'x-access-token': '${GetStorage().read('token')}'},
        );

        dynamic decodedData = jsonDecode(response.body);

        print("all tomarrow parties $decodedData");
        var totalPartiesTomarrow;
        List<Party> tomarrowParties = [];

        // Loop through parties and sort them into appropriate lists

        if (decodedData['data'] != null) {
          if (pageTomarrowCount == 1) {
            pageTomarrowCountresponse = decodedData['total_pages'];
            totalPartiesTomarrow = decodedData['total_recrods'];
            log('page count ::: $pageTomarrowCountresponse');

            pageTomarrowCount++;
          } else {
            pageTomarrowCount++;
          }
          List<dynamic> allParties = decodedData['data'];
          for (var party in allParties) {
            try {
              Party parsedParty = Party.fromJson(party);
              print(party);
              tomarrowParties.add(parsedParty);
            //  jsonPartyOrganisationDataTomm.value = tomarrowParties;
            } catch (e) {
              print('Error parsing tomorrow party: $e');
              if (!isloading) {
                refreshTomarrowController.refreshCompleted();
              } else {
                refreshTomarrowController.loadComplete();
              }
            }
          }
          ///setting length
       //   lengthOfTommParties.value = tomarrowParties.length;
          lengthOfTommParties.value = decodedData['total_recrods'];
          log("length of tomarrow $lengthOfTommParties");
          ///setting number of party
          jsonPartyOrganisationDataTomm.addAll(tomarrowParties);
          if (!isloading) {
            refreshTomarrowController.refreshCompleted();
          } else {
            refreshTomarrowController.loadComplete();
          }
          update();
        }
      } else {
        if (!isloading) {
          refreshTomarrowController.refreshCompleted();
        } else {
          refreshTomarrowController.loadComplete();
        }
        Get.snackbar('Oops!', 'No More Party found ');
      }
    } catch (e) {
      print('Error fetching tomorrow parties: $e');
      if (!isloading) {
        refreshTomarrowController.refreshCompleted();
      } else {
        refreshTomarrowController.loadComplete();
      }
    }
  }

  Future<void> getUpcomingParty({required bool isloading}) async {
    try {
      var totalParties;
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty) {
        partyCity.value =
            individualProfileController.activeCity.value.toString();
      }
      if (!isloading) {
        pageUpcominmgCount = 1;
        pageUpcomingCountresponse = 1;
        startUpcoming = pageUpcominmgCount;
        jsonPartyOgranisationDataUpcomming.clear();
      } else {
        startUpcoming = pageUpcominmgCount;
      }
      if (pageUpcominmgCount <= pageUpcomingCountresponse) {

      http.Response response = await http.post(
        Uri.parse(API.getAllIndividualParty),
        body: {
          'status': '3',
          'city': partyCity.value.toLowerCase(),
          'filter_type': '2',
          'page_number': pageUpcominmgCount.toString(),
        },
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      dynamic decodedData = jsonDecode(response.body);

      print("all upcoming parties $decodedData");

      List<Party> upcomingParties = [];

      // Loop through parties and sort them into appropriate lists
      if (decodedData['data'] != null) {
        if (pageUpcominmgCount == 1) {

          pageUpcomingCountresponse = decodedData['total_pages'];
          totalParties = decodedData['total_recrods'];
          log('page count ::: $pageUpcomingCountresponse');

          pageUpcominmgCount++;
        } else {
          pageUpcominmgCount++;
        }
        List<dynamic> allParties = decodedData['data'];
        for (var party in allParties) {
          try {
            Party parsedParty = Party.fromJson(party);
            print(party);
            upcomingParties.add(parsedParty);
          } catch (e) {
            print('Error parsing upcoming party: $e');
            if (!isloading) {
              refreshUpcomingController.refreshCompleted();
            } else {
              refreshUpcomingController.loadComplete();
            }
          }
        }
        ///setting length
       // lengthOfUpcomingParties.value = upcomingParties.length;
       lengthOfUpcomingParties.value = decodedData['total_recrods'];
        ///setting number of party
        jsonPartyOgranisationDataUpcomming.addAll(upcomingParties);
       // jsonPartyOgranisationDataUpcomming.value = upcomingParties;
        if (!isloading) {
          refreshUpcomingController.refreshCompleted();
        } else {
          refreshUpcomingController.loadComplete();
        }
        update();
      }
    }else{
        if (!isloading) {
          refreshUpcomingController.refreshCompleted();
        } else {
          refreshUpcomingController.loadComplete();
        }
        Get.snackbar('Oops!', 'No More Party found ');
    }
    } catch (e) {
      print('Error fetching upcoming parties: $e');
      if (!isloading) {
        refreshUpcomingController.refreshCompleted();
      } else {
        refreshUpcomingController.loadComplete();
      }
    }
  }

  Future<void> getPopularParty({required bool isloading}) async {
    try {
      // Fetch all parties
      /// status': '1' current date parties
      /// status': '2' tomarrow date parties
      /// status': '3' tomarrow date parties
      ///
      /// 'filter_type': '2' == regular parties
      /// 'filter_type': '1' == popular parties
      if (individualProfileController.activeCity.value.isNotEmpty) {
        partyCity.value =
            individualProfileController.activeCity.value.toString();
        log('upcoming partycity ${partyCity.value}');
      }
      if (!isloading) {
        pagePopularCount = 1;
        pagePopularCountresponse = 1;
        startPopular = pagePopularCount;
        jsonPartyPopularData.clear();
      } else {
        startPopular = pagePopularCount;
      }
      log('else upcoming partycity ${partyCity.value}');
      if (pagePopularCount <= pagePopularCountresponse) {
      http.Response response = await http.post(
        Uri.parse(API.getAllIndividualParty),
        body: {
          'status': '5',
          'city': partyCity.value.toLowerCase(),
          'filter_type': '1',
          'page_number': pagePopularCount.toString(),
        },
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
            print(party);
            popularParties.add(parsedParty);
          } catch (e) {
            print('Error parsing popular party: $e');
            if (!isloading) {
              refreshPopluarController.refreshCompleted();
            } else {
              refreshPopluarController.loadComplete();
            }
          }
        }
        ///setting length
        lengthOfPopularParties.value = popularParties.length;

        ///setting number of party
        jsonPartyPopularData.value = popularParties;
        if (!isloading) {
          refreshPopluarController.refreshCompleted();
        } else {
          refreshPopluarController.loadComplete();
        }
        update();
      }
    }
      else{
        if (!isloading) {
          refreshPopluarController.refreshCompleted();
        } else {
          refreshPopluarController.loadComplete();
        }
        Get.snackbar('Oops!', 'No More Party found ');
      }
    } catch (e) {
      print('Error fetching popular parties: $e');
      if (!isloading) {
        refreshPopluarController.refreshCompleted();
      } else {
        refreshPopluarController.loadComplete();
      }
    }
  }

  /// GET ONLINE STATUS

  Future<void> getOnlineStatus() async {
    try {
      // Get current date
      DateTime now = DateTime.now();
      log("current" + now.toString());
      String onlineTime = now.add(Duration(minutes: 5)).toString();
      var time = onlineTime.split('.');
      onlineTime = time[0];

      log("After adding few min " + onlineTime.toString());
      final response = await http.post(
        Uri.parse(API.onlineStatus),
        body: {'online_time_expiry': onlineTime},
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        },
      );
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        if (decode['status'] == 1) {
          try {
            onlineStatus.value = decode['status'];
            GetStorage().write('plan_plan_expiry', decode['plan_plan_expiry']);
            String approval_date = decode['approval_date'];
            chatCount.value = decode['chat_count'];
            notificationCount.value = decode['notification_count'] ?? '0';
            if (approval_date != '') {
              GetStorage()
                  .write('approval_status', '${decode['approval_status']}');
              approvalStatus.value = GetStorage().read('approval_status');
              DateTime approvalTime = DateTime.parse(approval_date);
              DateTime newApproval_time = approvalTime.add(Duration(
                minutes: 15,
              ));
              if (newApproval_time.isAfter(DateTime.now())) {
                GetStorage().write('newUser', '1');
              } else {
                GetStorage().write('newUser', '0');
              }
              log('${approvalTime.toString()}');
            } else {
              GetStorage().write('approval_status', '0');
              approvalStatus.value = GetStorage().read('approval_status');
            }
            apiService.isLoading.value = false;
            update();
          } catch (e) {
            print("error catch for online status   $e  ");
            apiService.isLoading.value = false;
          }
        } else {
          print("Oops!', 'online status failed ");
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
