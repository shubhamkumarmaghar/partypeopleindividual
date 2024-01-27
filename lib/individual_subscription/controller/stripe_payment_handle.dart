import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

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
      'client_secret']);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet({required String paymentIntent }) async {
    try {

    //  var confirmpay =  await Stripe.instance.confirmPayment(paymentIntentClientSecret:  paymentIntent);

    //  log('confirm payment  ${confirmpay}');


      // 3. display the payment sheet.
      PaymentSheetPaymentOption? res = await Stripe.instance.presentPaymentSheet();
log('response ::: ${res.toString()}');
      Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        log('Error from Stripe: ${e.error.localizedMessage}');
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
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