import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/centralize_api.dart';

import '../models/city.dart';


class IndividualDashboardController extends GetxController {
  var buttonState = true;
  RxList<IndividualCity> allCityList = RxList();

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
        print(allCityList.length);
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
}
