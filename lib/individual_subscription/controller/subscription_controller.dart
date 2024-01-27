import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/individual_subscription/controller/stripe_payment_handle.dart';

import '../../centralize_api.dart';
import '../../individual_profile/controller/individual_profile_controller.dart';
import '../../widgets/payment_response_view.dart';
import '../model/SubscriptionModel.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController{
  Map<String, dynamic>? paymentIntent;
  RxString mobileNumber = ''.obs;
  RxString email = ''.obs;
  IndividualProfileController individualProfileController =
  Get.put(IndividualProfileController());
 SubscriptionModel subscriptionModel = SubscriptionModel(subsData: []);
 List<SubscriptionData> subsList = [];
 int subsOrderId = 0;
 RxBool isLoading = false.obs;

 @override
 void onInit(){
   super.onInit();
   getdata();
   getSubscriptionPlans();
  /* individualProfileController.individualProfileData();
  email.value =
     individualProfileController.email.value;
   mobileNumber.value = individualProfileController.userMobile.value;*/
 }

 void getdata ()async{
   getSubscriptionPlans();
  await individualProfileController.individualProfileData();
   email.value = individualProfileController.email.value;
   mobileNumber.value = individualProfileController.userMobile.value;
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


    /// for handling stripe payment

 Future<void> stripeMakePayment(
      {
        required String name,
        required String email,
        required String phone ,
        required String city,
        required String country,
        required String postalCode,
        required String state,
        required String amount,
        required String orderId,
        required String type,

      }
      ) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');

      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: BillingDetails(
                  name: name,
                  email: email,
                  phone: phone,
                  address: Address(
                      city: city,
                      country: country,
                      line1: '',
                      line2: '',
                      postalCode: postalCode,
                      state: state)),
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Ikay'))
          .then((value) {

      });


      //STEP 3: Display Payment sheet
      displayPaymentSheet(paymentIntent: paymentIntent![
      'client_secret'],amount: amount);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet({required String paymentIntent ,required String amount}) async {
    try {

      //  var confirmpay =  await Stripe.instance.confirmPayment(paymentIntentClientSecret:  paymentIntent);

      //  log('confirm payment  ${confirmpay}');


      // 3. display the payment sheet.
      PaymentSheetPaymentOption? res = await Stripe.instance.presentPaymentSheet();
      log('response ::: ${res.toString()}');
      await updateSubsPaymentStatus(subsId: paymentIntent, paymentStatus: '1',);
      Get.to(  PaymentResponseView(isSuccess: '1',orderId: paymentIntent,amount: amount ,));
      Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        log('Error from Stripe: ${e.error.localizedMessage}');
        if('${e.error.localizedMessage}' == 'The payment flow has been canceled'){
          Fluttertoast.showToast(
              msg: ' ${e.error.localizedMessage}');
        }
        else{
        await updateSubsPaymentStatus(subsId: paymentIntent, paymentStatus: '0',);
        Get.to(  PaymentResponseView(isSuccess: '0',orderId: paymentIntent,amount: amount ,));
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
        }
      } else {
        await updateSubsPaymentStatus(subsId: paymentIntent, paymentStatus: '0',);
        Get.to(  PaymentResponseView(isSuccess: '0',orderId: paymentIntent,amount: amount ,));
        log('Unforeseen error: ${e}');
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log('response :: ${json.decode(response.body)}');
      return json.decode(response.body);
    } catch (err) {
      log('error ::: $err');
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

}