import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../api_helper_service.dart';
import '../../centralize_api.dart';
import '../model/book_party_list_model.dart';

class BookPartyListController extends GetxController {
 APIService apiService = Get.put(APIService());

 PartyBookingList partyBookingModel = PartyBookingList();



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBookingListData();
    //getReportedData();
  }
  ///Booking List  data
 Future<void> getBookingListData() async {
    try {
      http.Response response = await http.post(
          Uri.parse(API.getPartyBookingHistory),
          headers: {
            'x-access-token': '${GetStorage().read('token')}',
          });

      print("response of block data ${response.body}");


      if (jsonDecode(response.body)['data']!= null ) {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;
        var data=PartyBookingList.fromJson(usersData) ;
        var list = data.data ?? [];
        for(var data1 in list){
         log('transction  id ${data1.id}');
        }

       partyBookingModel = data;

       // dynamic decodedData = jsonDecode(response.body);
      // visitorinfo =  decodedData['data'];
      // return decodedData;

      } else {
        print("No data found ${response.body}");
      }
    } on Exception catch (e) {
      print('Exception in transaction data ${e}');
    }
   update();
  }

 Future<void> getBookingSingleData() async {
   try {
     http.Response response = await http.post(
         Uri.parse(API.getPartyBookingHistory),
         headers: {
           'x-access-token': '${GetStorage().read('token')}',
         });

     print("response of block data ${response.body}");


     if (jsonDecode(response.body)['data']!= null ) {
       var usersData = jsonDecode(response.body ) as Map<String,dynamic>;
       var data=PartyBookingList.fromJson(usersData) ;
       var list = data.data ?? [];
       for(var data1 in list){
         log('transction  id ${data1.id}');
       }

       partyBookingModel = data;

       // dynamic decodedData = jsonDecode(response.body);
       // visitorinfo =  decodedData['data'];
       // return decodedData;

     } else {
       print("No data found ${response.body}");
     }
   } on Exception catch (e) {
     print('Exception in transaction data ${e}');
   }
   update();
 }
}
