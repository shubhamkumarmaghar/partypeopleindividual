import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../centralize_api.dart';
import '../../individual_profile/controller/individual_profile_controller.dart';
import '../model/SubscriptionModel.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController{

  IndividualProfileController individualProfileController =
  Get.put(IndividualProfileController());
 SubscriptionModel subscriptionModel = SubscriptionModel(subsData: []);
 List<SubscriptionData> subsList = [];
 int subsOrderId = 0;
 RxBool isLoading = false.obs;

 @override
 void onInit(){
   super.onInit();
   getSubscriptionPlans();
   individualProfileController.individualProfileData();
 }
 
 Future<void> getSubscriptionPlans() async{
   try {
     isLoading.value = true;
     final response = await http.post(Uri.parse(
         API.getSubscriptionPlan),
       headers: <String, String>{
         'x-access-token': '${GetStorage().read('token')}',
       },);
     if (response.statusCode == 200) {
       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       print(jsonResponse);
       if (jsonResponse['status'] == 1 &&
           jsonResponse['message'].contains('Data Found')) {
         var data = SubscriptionModel.fromJson(jsonResponse);
         subscriptionModel = data;
         isLoading.value = false;
         update();

       }
     }
     else
       {
         log('subscription_plans api response is not 200');
       }
   }
   catch(e){
     log("$e");
   }
 }

 Future<String> subscriptionPurchase({required String subsId}) async{
   String value ='0';
   try {
     final response = await http.post(Uri.parse(
         API.userSubscriptionPurchase),
       headers: <String, String>{
         'x-access-token': '${GetStorage().read('token')}',
       },
       body: { 'subscription_id':subsId}
     );
     if (response.statusCode == 200) {

       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       print(jsonResponse);
       if (jsonResponse['status'] == 1 && jsonResponse['message'].contains(
           'Subscription plan puarchase successfully.')) {
         subsOrderId = jsonResponse['subscription_purchase_id'];
         update();
         value = '1';
       }
       else if (jsonResponse['status'] == 0 &&
           jsonResponse['message'].contains('')) {
         Get.snackbar('Error', '${jsonResponse['message']}');
         update();
         value = '0';
       }
       else {
         update();
      log('${jsonResponse['message']}');
         value ='0';
       }
     }
     else{
       log('subscription_purchase api response is not 200');
       value = '0';
     }
   }
   catch(e)
   {
     log("$e");
   }
   return value ;
 }

  Future<void> updateSubsPaymentStatus({required String subsId,required String paymentStatus,}) async{
   try {
     log('$subsId  $paymentStatus ');
     final response = await http.post(Uri.parse(
         API.updateSubscriptionStatus),
         headers: <String, String>{
           'x-access-token': '${GetStorage().read('token')}',
         },
         body: { 'subscription_purchase_id':subsId.toString(),
                  'payment_status':paymentStatus.toString(),
                //  'payment_response':paymentResponse?.toString(),
                 // 'payment_id' :paymentId?.toString()
                }
     );
     log('STATUS CODE :: ${response.statusCode}');
     if (response.statusCode == 200) {

       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       print(jsonResponse);

       if (jsonResponse['status'] == 1 && jsonResponse['message'].contains(
           'Your transaction successfully.')) {
         log('${jsonResponse['message']}');
         update();
         Get.snackbar("",'${jsonResponse['message']}' );
       }
       else {
         update();
         log('${jsonResponse['message']}');
       }
     }
     else{
       log('update subscription api response is not 200');
     }
   }
   catch(e)
   {
     log("dfgmhmgmgh $e");
   }
    }

}