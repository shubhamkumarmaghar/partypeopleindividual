import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../api_helper_service.dart';
import '../model/people_profile_model.dart';

class PeopleProfileController extends GetxController {

  PeopleProfileData peopleProfileData = PeopleProfileData();
  APIService apiService = Get.find();
  List<OrganizationAmenities> amentiesdata=[];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //PeopleViewed('213');
  }


  Future<void> PeopleViewed(String id) async {
    final response = await http.post(
      Uri.parse(
          'http://app.partypeople.in/v1/account/get_individual_profile_view'),
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
          // amenties = amentiesdata;

         /* var list = data.data ?? [];

            for(var data1 in list){
            log('visited user id ${data1.id}');
          }


         */
          peopleProfileData = data;
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
