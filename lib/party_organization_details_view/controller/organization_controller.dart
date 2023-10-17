import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/individual_nearby_people_profile/controller/people_profile_controller.dart';

import '../../centralize_api.dart';
import '../../individual_profile/controller/individual_profile_controller.dart';
import '../model/organization_details_model.dart';

class OrganizationController extends GetxController {
  OrganizationDetailsModel? organizationDetailsModel;

  var isApiLoading = false;
  String? userId;
  List<ProfileImageWithStatus> profileImages =[];
  List<MultiSelectCard> listOfAmenities = [];

  OrganizationController({this.userId});

  @override
  void onInit(){
    super.onInit();
     userId = Get.arguments as String;
    //Future.delayed(Duration(seconds: 1),() => getOrganizationData(),);
     getOrganizationData();


  }



  void getProfileImages()
  {
    var data = organizationDetailsModel?.data![0];
    if( data?.coverPhoto != null ){
      profileImages.add(ProfileImageWithStatus(image: data?.coverPhoto, status: '${data?.profilePicApprovalStatus}'));
      //  profileImages.add(coverPhotoURL.value);
    }
    if(data?.profilePic != null ){
      profileImages.add(ProfileImageWithStatus(image: '${data?.profilePic}', status: '${data?.profilePicApprovalStatus}'));
      // profileImages.add(profilePhotoURL.value);
    }
    if( data?.profilePicB != null){
      profileImages.add(ProfileImageWithStatus(image: '${data?.profilePicB}', status: '${data?.profilePicApprovalStatusB}'));
      // profileImages.add(profileB.value);
    }
    if( data?.profilePicC != null){
      //profileImages.add(profileC.value);
      profileImages.add(ProfileImageWithStatus(image: '${data?.profilePicC}', status: '${data?.profilePicApprovalStatusC}'));
    }
    if( data?.profilePicD != null  ){
      //profileImages.add(profileD.value);
      profileImages.add(ProfileImageWithStatus(image: '${data?.profilePicD}', status: '${data?.profilePicApprovalStatusD}'));
    }
    if(data?.profilePicE != null ){
      //profileImages.add(profileE.value);
      profileImages.add(ProfileImageWithStatus(image: '${data?.profilePicE}', status: '${data?.profilePicApprovalStatusE}'));
    }
    profileImages.forEach((element) {
      print(element.toString());
    });
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
        log(response.body);
        final decodedData = jsonDecode(response.body);

        organizationDetailsModel =
            OrganizationDetailsModel.fromJson(decodedData);
        print("${organizationDetailsModel?.data?[0]?.organizationAmenities?[0]?.name}");
        getAmenities();
        getProfileImages();
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
