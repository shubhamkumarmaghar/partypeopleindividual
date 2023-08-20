import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/SubscriptionModel.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController{


 SubscriptionModel subscriptionModel = SubscriptionModel();
 List<SubscriptionData> subsList = [];

 @override
 void onInit(){
   super.onInit();
   getSubscriptionPlans();
 }
 
 Future<void> getSubscriptionPlans() async{
     final  response = await http.post(Uri.parse('https://app.partypeople.in/v1/subscription/subscription_plan'),
        headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },);
     if (response.statusCode == 200) {
       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       print(jsonResponse);
       if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('Data Found'))
         {
           var data = SubscriptionModel.fromJson(jsonResponse);
           subscriptionModel = data;
           update();
         }
     }
 }
}