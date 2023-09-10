import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../individual_profile/controller/individual_profile_controller.dart';
import 'active_city_select.dart';

class PaymentResponseView extends StatefulWidget {
  String orderId;
  String isSuccess;

  PaymentResponseView({
    super.key,
    required this.orderId,
    required this.isSuccess,
  });

  @override
  State<PaymentResponseView> createState() => _PaymentResponseViewState();
}

IndividualProfileController individualProfileController =
    Get.put(IndividualProfileController());

class _PaymentResponseViewState extends State<PaymentResponseView> {
  @override
  final _mainHeight = Get.height;
  final _mainWidth = Get.width;

  @override
  void initState() {
    super.initState();
    individualProfileController.getAllCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Container(
        width: _mainWidth,
        height: _mainHeight,
        child: Column(
          children: [
            SizedBox(
              height: _mainHeight * 0.1,
            ),
            Card(
              elevation: 5,
             shape: RoundedRectangleBorder(
            side: BorderSide(
            color: Colors.red.shade900,
            ),
        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
      ),
             margin: EdgeInsets.all(_mainWidth*0.05),
              child: Column(
                children: [
                  SizedBox(
                    height: _mainHeight * 0.05,
                  ),
                Container(
                height: _mainHeight * 0.2,
                width: _mainWidth * 0.7,
                child: Lottie.network(
                    widget.isSuccess == '1'
                        ? 'https://assets-v2.lottiefiles.com/a/20e4a6f2-116f-11ee-b864-bf9e43a0b86d/gjvNK2B3cD.json'
                        : 'https://assets-v2.lottiefiles.com/a/4083ce28-117b-11ee-b045-7790e649eb6a/pP3H8eK2z6.json',
                    width: _mainWidth * 0.05,
                    height: _mainHeight * 0.05),
              ),
                SizedBox(
                height: _mainHeight * 0.01,
              ),
                Text(
                  'Subscription Payment ${widget.orderId == '1' ? 'Successful' : 'Failed'}',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Order ID : ${widget.orderId}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: _mainWidth * 0.1,
                  indent: _mainWidth * 0.05,
                  endIndent: _mainWidth * 0.05,
                ),
                SizedBox(
                  height: _mainHeight * 0.005,
                ),
                Text(
                  'Amount Paid: ₹${widget.orderId}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Payed By : EasyBuzz',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                  SizedBox(
                    height: _mainHeight * 0.05,
                  ),
              ],
              ),
            ),



            SizedBox(
              height: _mainHeight * 0.05,
            ),
            widget.isSuccess =='1' ?
            Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              margin: EdgeInsets.all(15),
              // adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Preferred Location",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    "* Preferred Location is the location where you want to explore parties & party mates. *",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ActiveCitySelect(),
                      ),
                    ],
                  ),
                ],
              ),
            ):
            Container(),

            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                    onPressed: () {}, child: Text('Go to HomePage')))
          ],
        ),
      ),
    );
  }
}
