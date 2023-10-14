import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../api_helper_service.dart';
import '../../centralize_api.dart';
import '../../widgets/individual_amenities.dart';
import '../model/people_profile_model.dart';

class PeopleProfileController extends GetxController {

  PeopleProfileData peopleProfileData = PeopleProfileData();
  APIService apiService = Get.find();
  List<OrganizationAmenities> amentiesdata=[];
  List<Category> categories = [];
  List<CategoryList> categoryLists = [];
  List<OrganizationAmenities>? amenties=[];
  List selectedAmenities = [];
  String userId='';
  List profileImages = [];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    userId = Get.arguments as String;
    PeopleViewed(userId);
  }

  Future<void> _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(API.individualOrganizationAmenities),
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

          if (data['status'] == 1) {
            categories = (data['data'] as List)
                .map((category) => Category.fromJson(category))
                .toList();

            categories.forEach((category) {
              categoryLists.add(CategoryList(
                  title: category.name, amenities: category.amenities));
            });
            getSelectedID();
          } else {
            print('Error with the data status: ${data['status']}');
          }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  void getSelectedID() {

    for (var i = 0; i < amentiesdata.length; i++) {
      var amenityName = amentiesdata[i].id;

        categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.id == amenityName) {
              if (selectedAmenities
                  .contains(amenity.id)) {
              } else {
                selectedAmenities.add(amenity.id);
              }
              amenity.selected = true;
              update();
            }
          });
        });
    }
  }


  Future<void> PeopleViewed(String id) async {
    final response = await http.post(
      Uri.parse(
          API.getIndividualProfileView),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'user_id': id
      },
    );
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

        if (jsonDecode(response.body)['status'] == 1 &&
            jsonDecode(response.body)['message'] == 'Found') {
          print('User data found');
          var usersData = jsonDecode(response.body) as Map<String, dynamic>;

          var data = PeopleProfileData.fromJson(usersData);

           amentiesdata = data.data?.organizationAmenities??[];

            for(var data1 in amentiesdata){
          }
          peopleProfileData = data;
            _fetchData();
          var peopledata = peopleProfileData.data;
          if(peopledata?.coverPhoto != null || peopledata?.coverPhoto !=''  ){
            profileImages.add(peopledata?.coverPhoto);
          }
          if(peopledata?.profilePic != null || peopledata?.profilePic !='' ){
            profileImages.add(peopledata?.profilePic);
          }
          profileImages.forEach((element) {log('$element');});
       /*   if(peopledata?.imageB != null || peopledata?.imageB !=''  ){
            profileImages.add(peopledata?.imageB);
          }
          if(peopledata?.imageC  != null || peopledata?.imageC !='' ){
            profileImages.add(peopledata?.imageC);
          }
          if(peopledata?.imageD  != null || peopledata?.imageD !=''  ){
            profileImages.add(peopledata?.imageD);
          }
          if(peopledata?.imageE  != null || peopledata?.imageE  !='' ){
            profileImages.add(peopledata?.imageE);
          }*/
          update();
        }
        else {
          print('data not found');
        }
      }
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('data not found');
      }
      update();
    }
  }
