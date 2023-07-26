import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../api_helper_service.dart';
import '../model/blocked_info_model.dart';

class BlockReportController extends GetxController {
 APIService apiService = Get.put(APIService());

 BlockInfoModel blockInfoModel = BlockInfoModel();
 BlockInfoModel reportedInfoModel = BlockInfoModel();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBlockedData();
    //getReportedData();
  }
  ///Blocked  data
 Future<void> getBlockedData() async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://app.partypeople.in/v1/account/get_individual_block_list'),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });

      print("response of block data ${response.body}");


      if (jsonDecode(response.body)['data']!= null && jsonDecode(response.body)['message'] == 'User block list found') {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;
        var data=BlockInfoModel.fromJson(usersData) ;
        var list = data.data ?? [];
        for(var data1 in list){
         log('blocked user id ${data1.id}');
        }

       blockInfoModel = data;

       // dynamic decodedData = jsonDecode(response.body);
      // visitorinfo =  decodedData['data'];
      // return decodedData;

      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in blocked data ${e}');
    }
   update();
  }

 Future<void> DoBlockUnblockPeople(String id,String status) async {
   try {
     http.Response response = await http.post(
         Uri.parse('http://app.partypeople.in/v1/account/individual_user_block'),
         headers: {
           'x-access-token': '${GetStorage().read('token')}',
         },
         body: {
           'block_user_id': id,
           'status' : status
     });

     print("response of unblock data ${response.body}");


     if (jsonDecode(response.body)['status'] == '0') {
       print("User Unblocked successfully");

     }
     else if(jsonDecode(response.body)['status'] == '1'){
       print("User blocked successfully");
     }
       else {
       print("User Unblocked failed ${response.body}");
     }
   } on Exception catch (e) {
     print('Exception in blocked data ${e}');
   }
   update();
 }


 ///Reported data
 Future<void> getReportedData() async {
   try {
     http.Response response = await http.post(
         Uri.parse('http://app.partypeople.in/v1/account/get_individual_view_list'),
         headers: {
           'x-access-token': '${GetStorage().read('token')}',
         });

     print("response of visited data ${response.body}");


     if (jsonDecode(response.body)['data']!= null && jsonDecode(response.body)['message'] == 'Data Found') {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;


       var data=BlockInfoModel.fromJson(usersData) ;
       var list = data.data ?? [];
       for(var data1 in list){
         log('visited user id ${data1.id}');
       }

       blockInfoModel = data;

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

}
