import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../centralize_api.dart';
import '../model/organization_details_model.dart';

class OrganizationController extends GetxController {
  OrganizationDetailsModel? organizationDetailsModel;

  var isApiLoading = false;
  String? userId;
  List<MultiSelectCard> listOfAmenities = [];

  OrganizationController({this.userId});

  @override
  void onInit(){
    super.onInit();
     userId = Get.arguments as String;
    //Future.delayed(Duration(seconds: 1),() => getOrganizationData(),);
     getOrganizationData();

  }




  Future<void> getOrganizationData() async {
    isApiLoading = true;

    try {
      http.Response response = await http.post(
        Uri.parse(API.organizationInfo),
        body: {'user_id': userId},
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        organizationDetailsModel =
            OrganizationDetailsModel.fromJson(decodedData);
        print("${organizationDetailsModel?.data?[0]?.organizationAmenities?[0]?.name}");
        getAmenities();
      }
      isApiLoading = false;
      update();
    } catch (e) {
      print('Error fetching organization: $userId ---- $e');
      update();
    }
  }

  Future<void> getAmenities() async {

    List<OrganizationAmenities?> jsonAddAmenitiesData = organizationDetailsModel?.data?[0]?.organizationAmenities ?? [];

      listOfAmenities.clear();
      int list=jsonAddAmenitiesData.length;
      for (int i = 0; i < list; i++) {
          listOfAmenities.add(MultiSelectCard(
              value: jsonAddAmenitiesData[i]?.name,
              enabled: false,
              perpetualSelected: false,
              highlightColor: Colors.red,
              selected: false,
              label: jsonAddAmenitiesData[i]?.name));

      }

  }


}
