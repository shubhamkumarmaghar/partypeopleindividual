import 'dart:core';
import 'dart:developer';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:partypeopleindividual/individual_subscription/controller/subscription_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../widgets/webView.dart';
import '../model/SubscriptionModel.dart';

class SubscriptionView extends StatefulWidget {
  String subText ;
  String iconText;
  SubscriptionView({required this.subText , required this.iconText});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
//  static MethodChannel _channel = MethodChannel('easebuzz');
 SubscriptionController subController = Get.put(SubscriptionController());
 // Razorpay _razorpay = Razorpay();

 /* void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Successul ${response.signature} (${response.paymentId})');
    subController.updateSubsPaymentStatus(subsId: subController.subsOrderId, paymentStatus: 1, paymentResponse: response.orderId.toString(), paymentId: response.paymentId.toString(),);
    //SubscriptionController.updateSubsPaymentStatus(subsId: subsId, paymentStatus: paymentStatus, paymentResponse: paymentResponse, paymentId: paymentId)

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      // Payment failure logic
      subController.updateSubsPaymentStatus(subsId: subController.subsOrderId, paymentStatus: 0, paymentResponse: response.message.toString(), paymentId: response.code.toString(),);

      print('Payment error: ${response.message} (${response.code})');
    } catch (e) {
      print('Error in payment error callback: $e');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    try {
      // External wallet logic
      print('External wallet selected: ${response.walletName}');
    } catch (e) {
      print('Error in external wallet callback: $e');
    }
  }*/

  @override
  void initState() {
    super.initState();
  //  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }


  @override
  void dispose() {
    super.dispose();

   // _razorpay.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
            /*  decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.red.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),*/
            ),
        /*    title: Text("Wishlist",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
        ),*/
      ),
      body: GetBuilder<SubscriptionController>(
          init: SubscriptionController(),
          builder: (controller) {
            if (controller.isLoading == false) {
              return Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(1, -0.45),
                  radius: 0.9,
                  colors: [
                    Color(0xff7e160a),
                    Color(0xff2e0303),
                  ],
                  stops: [0.0, 1],
                  transform: GradientXDTransform(
                    0.0,
                    -1.0,
                    1.23,
                    0.0,
                    -0.115,
                    1.0,
                    Alignment(0.0, 0.0),
                  ),
                ),
              ),
              height: Get.height,
              width: Get.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.11),
                    Text(
                      'Get Subscription',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      widget.subText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 100),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30,),
                    Neumorphic(style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle(),
                        shape: NeumorphicShape.concave),child: Lottie.network(widget.iconText,width: Get.width*0.2,height: Get.width*0.2)),
                    SizedBox(height: 30,),


                    SizedBox(height: 30,),
                    CarouselSlider(
                      items: [
                        GestureDetector(
                          onTap: () async{
                            String value = await controller.subscriptionPurchase(subsId: controller.subscriptionModel.subsData![0].id);
                           if(value =='1')
                            selectPlanBottom(context: context,name:  controller.subscriptionModel.subsData![0].name , amount:controller.subscriptionModel.subsData![0].amount );
                           },
                          child: subscriptionPlansView(
                              subscriptionData:
                                  controller.subscriptionModel.subsData[0]),
                        ),
                        GestureDetector(
                          onTap: () async{
                            String value = await controller.subscriptionPurchase(subsId: controller.subscriptionModel.subsData![1].id);
                            if(value =='1')
                              selectPlanBottom(context: context,name:  controller.subscriptionModel.subsData![1].name , amount:controller.subscriptionModel.subsData![1].amount );
                          },
                          child: subscriptionPlansView(
                              subscriptionData:
                              controller.subscriptionModel.subsData[1]),
                        ),
                        GestureDetector(
                          onTap: () async{
                            String value = await controller.subscriptionPurchase(subsId: controller.subscriptionModel.subsData![2].id);
                            if(value =='1')
                              selectPlanBottom(context: context,name:  controller.subscriptionModel.subsData![2].name , amount:controller.subscriptionModel.subsData![2].amount );
                          },
                          child: subscriptionPlansView(
                              subscriptionData:
                              controller.subscriptionModel.subsData[2]),
                        ),

                        /*  ListView.builder(itemCount:controller.subscriptionModel.subsData?.length ,
                     scrollDirection: Axis.horizontal,
                     itemBuilder: (context , index){
                       data = controller.subscriptionModel.subsData != null ?
              controller.subscriptionModel.subsData![index]:
                  SubscriptionData(description: "",amount: "",day: "",name: "",id: "",status: "");

                   return subscriptionPlansView(
                       id: data.id ,
                       name: data.name ,
                       day: data.day ,
                       amount: data.amount ,
                       description: data.description ,
                       Status: data.status);
                     }
                     ),*/
                        //1st Image of Slider
                        /*FittedBox(
                    child: Container(
                      margin: EdgeInsets.all(6.0),
                      width: Get.width*.8,
                     height: Get.height*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Row(
                          children: [
                            Container(
                              height: Get.width*0.025,
                              margin: EdgeInsets.all( 10),
                                child: Icon(Icons.calendar_month,size: 50,color: Colors.red.shade200,)),
                          ],
                        ),

                        Center(child: Text('1/Day',style: TextStyle(fontSize: 28,color: Colors.blue,fontWeight: FontWeight.w700),)),
                            SizedBox(height: 10,),
                            FittedBox(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,
                              width: Get.width*0.75,
                              height:Get.width*0.4,
                              child: Text("Go to the Subscription Plan list and click on New.\n Select the item that will be subscribed.\nSelect a Price Determination whether Fixed or based on a Price List.\nSet a Billing Interval whether Daily, Weekly, Monthly, or Yearly.",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.normal))),
                        ),
                      ]
                      ),
                    ),
                  ),*/
                      ],
                      //Slider Container properties
                      options: CarouselOptions(
                        height: Get.height * 0.5,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        autoPlay: true,
                        //aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.75,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /*

              SizedBox(height: 20,),
              Text(
                'No Thanks',textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16),
              ),*/

                 /*   Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Benefits:',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        "✔ Unlimited Chat Access .\n"
                        "✔  Unlimited active location change .\n"
                        "✔ View and likes visible . ",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 12),
                      ),
                    ), */
                  ]),
            );
            } else {
              return Container(width: Get.width,height: Get.height,
              color: Colors.white,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: Colors.black,
                ),
              ),
            );
            }
          }),
    );
  }

  Widget subscriptionPlansView({required SubscriptionData? subscriptionData}) {
    return Stack(children: [
      FittedBox(
        child: Container(
          margin: EdgeInsets.all(6.0),
          width: Get.width * .8,
          height: Get.height * 0.48,
          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(20.0),
            // boxShadow: [BoxShadow(color: Colors.white,blurRadius: 2,spreadRadius: 2,offset:Offset.fromDirection(1.0),blurStyle:BlurStyle.inner  )],
                color: Colors.white,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                /*    Color(0xfff2d5f7),
                    Color(0xffe6acef),
                    Color(0xffd982e6),
                    Color(0xffcd59de),
                    Color(0xffc02fd6),*/

                  /*  Color(0xffd1dce6),
                    Color(0xffa2bace),
                    Color(0xff7497b5),
                    Color(0xff45759d),
                    Color(0xff175284),
*/
                    Color(0xffee216c),
                    Color(0xffee216c),
                    Color(0xffee216c),
                    Color(0xfff14d89),
                    Color(0xfff57aa7),
                    Color(0xfff8a6c4),
                    Color(0xfffcd3e2),
                   // Colors.red.shade800,
                    //Colors.red.shade700,
                    //Colors.red.shade500,
                   // Colors.red.shade400,
                   // Colors.red.shade300,
                   // Colors.black45,
                    //Colors.black54,
                 //   Colors.black87,
                   // Colors.black,
                  ]

    ),

                  ),

          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        height: Get.width * 0.01,
                        margin: EdgeInsets.all(10),
                        child: Icon(
                          Icons.calendar_month,
                          size: 70,
                          color: Colors.red.shade50,
                        )),
                  ],
                ),
                Center(
                    child: Text(
                  subscriptionData?.name ?? '',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700),
                )),
                Center(
                  child: CircleAvatar(radius: 40,
                      backgroundColor: Colors.red.shade400,
                      child: FittedBox(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                    '₹${subscriptionData?.amount}',
                    style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                  ),
                        ),
                      )),
                ),
               
                FittedBox(
                  child: Container(
                      // color: Colors.red.shade900,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      width: Get.width * 0.65,
                      height: Get.width * 0.45,
                      child: Text(subscriptionData?.description ?? "",
                          maxLines: 8,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600))),
                ),
              ]),
        ),
      ),
   /*   Positioned(
     // top: Get.height*0.001-20,
      bottom: Get.height*.65,
      left: 30,
        right: 30,
        child:
        Container(
          margin: EdgeInsets.only(right: Get.width * 0.028),
          height: MediaQuery.of(context).size.width * 0.12,
          width: MediaQuery.of(context).size.width * 0.75,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
            //const Color(0xFFffa914),
          ),
        ),
      ),*/
    ]);
  }

  void  selectPlanBottom({required BuildContext context , required String amount , required String name}){
     showModalBottomSheet(context: context,backgroundColor: Colors.red.shade100, shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.vertical(
         top: Radius.circular(20),
       ),
     ),builder: (context)

    {
      return Container(
        height: Get.height*0.2,
        width: Get.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('For $name Subscription plan' , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600, color: Colors.black),),
            SizedBox(height: 30,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text('Total Amount:' , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w600, color: Colors.grey),),
              Text('₹'+amount , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w600, color: Colors.blue),),
            ]),
          Spacer(),
            GestureDetector(
              onTap: () async {
                {
                  Navigator.pop(context);
                  Get.to(WebViewContainer(url:'https://app.partypeople.in/easebuzz/easebuzz.php?api_name=initiate_payment'
                      '&amount=${double.parse(amount)}'
                     // '&amount=${double.parse('10')}'
                      '&phone=${subController.individualProfileController.userMobile.value}'
                      '&email=${subController.individualProfileController.email.value}'
                      '&firstname=${subController.individualProfileController.username.value}'
                      '&country=${subController.individualProfileController.country.value}'
                      '&state=${subController.individualProfileController.state.value}'
                      '&city=${subController.individualProfileController.city.value}'
                      '&order_id=${subController.subsOrderId}'
                      '&zipcode=${subController.individualProfileController.pincode.value}'
                      '&usertype=Individual'));

               /* var options = {
                    'key': 'rzp_test_qiTDenaoeqV1Zr',
                    // Replace with your Razorpay API key
                    'amount': (int.parse(amount)) * 100,
                    // Amount in paise (e.g., for INR 500.00, use 50000)
                    'name': 'PARTY PEOPLE ',
                    'description': 'RAMBER ENTERTAINMENT PVT LTD',
                    'prefill': {
                      'contact': 'CUSTOMER_CONTACT_NUMBER',
                      'email': 'CUSTOMER_EMAIL'
                    },
                    'external': {
                      'wallets': ['paytm'] // Supported wallets
                    }
                  };

                  try {
                    _razorpay.open(options);
                  } catch (e) {
                    print(e.toString());
                  }
                  */
/*
                    String access_key = "555a2b009214573bd833feca997244f1721ac69d7f2b09685911bc943dcf5201";
                    String pay_mode = "test";
                    Object parameters =
                    {
                      "access_key":access_key,
                      "pay_mode":pay_mode,
                    //  "amount": (double.parse(amount)),
                    };
                    final payment_response = await _channel.invokeMethod("payWithEasebuzz", parameters);
                  String result = payment_response['result'];

                    /* payment_response is the HashMap containing the response of the payment.
You can parse it accordingly to handle response */
*/
                };
              },
              child: Container(
                margin: EdgeInsets.only(right: Get.width * 0.028),
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.amber,
                 border: Border.all(color: Colors.red.shade900)
                  //const Color(0xFFffa914),
                ),
                child:Text(
                  'CONTINUE',textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20),
                ),

              ),
            ),
          ],
        ),
      );
    }
    );
  }
}
