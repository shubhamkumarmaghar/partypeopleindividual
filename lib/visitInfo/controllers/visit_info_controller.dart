import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../api_helper_service.dart';
import '../model/visitinfo.dart';
import '../views/visit_info_view.dart';

class visitInfoController extends GetxController {
 late List visitorinfo;
 RxString name = 'Hello'.obs;
 APIService apiService = Get.put(APIService());
 RxList<VisitInfoModel> visitorinfolist = <VisitInfoModel>[].obs;
 VisitInfoModel visiterdataModel = VisitInfoModel();
 VisitInfoModel visiteddataModel = VisitInfoModel();
 VisitInfoModel likedataModel = VisitInfoModel();
 RxInt lengthOfvisitorinfo = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getVisitorData();
    getVisitedData();
    getLikePeopleData();
  }
  ///visitor data
 Future<void> getVisitorData() async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://app.partypeople.in/v1/account/get_individual_visitor_list'),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });

      print("response of visitor data ${response.body}");


      if (jsonDecode(response.body)['data']!= null && jsonDecode(response.body)['message'] == 'Data Found') {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;


        var data=VisitInfoModel.fromJson(usersData) ;
        var list = data.data ?? [];
        for(var data1 in list){
         log('visitor user id ${data1.id}');
        }

       visiterdataModel = data;

       // dynamic decodedData = jsonDecode(response.body);
      // visitorinfo =  decodedData['data'];
      // return decodedData;

      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in Visitor data ${e}');
    }
   update();
  }

 ///visited data
 Future<void> getVisitedData() async {
   try {
     http.Response response = await http.post(
         Uri.parse('http://app.partypeople.in/v1/account/get_individual_view_list'),
         headers: {
           'x-access-token': '${GetStorage().read('token')}',
         });

     print("response of visited data ${response.body}");


     if (jsonDecode(response.body)['data']!= null && jsonDecode(response.body)['message'] == 'Data Found') {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;


       var data=VisitInfoModel.fromJson(usersData) ;
       var list = data.data ?? [];
       for(var data1 in list){
         log('visited user id ${data1.id}');
       }

       visiteddataModel = data;

       // dynamic decodedData = jsonDecode(response.body);
       // visitorinfo =  decodedData['data'];
       // return decodedData;

     } else {
       print("No data found ${response.body}");
     }
   } on Exception catch (e) {
     print('Exception in Visited data ${e}');
   }
   update();
 }

 ///like people data
 Future<void> getLikePeopleData() async {
   try {
     http.Response response = await http.post(
         Uri.parse('http://app.partypeople.in/v1/account/get_individual_like_list'),
         headers: {
           'x-access-token': '${GetStorage().read('token')}',
         });

     print("response of liked people data ${response.body}");


     if (jsonDecode(response.body)['data']!= null && jsonDecode(response.body)['message'] == 'Data Found') {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;


       var data=VisitInfoModel.fromJson(usersData) ;
       var list = data.data ?? [];
       for(var data1 in list){
         log('liked people  user id ${data1.id}');
       }

       likedataModel = data;

       // dynamic decodedData = jsonDecode(response.body);
       // visitorinfo =  decodedData['data'];
       // return decodedData;

     } else {
       print("No data found ${response.body}");
     }
   } on Exception catch (e) {
     print('Exception in liked people  data ${e}');
   }
   update();
 }
}
