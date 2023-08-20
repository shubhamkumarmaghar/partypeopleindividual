import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:partypeopleindividual/individual_subscription/controller/subscription_controller.dart';
import 'package:sizer/sizer.dart';

import '../model/SubscriptionModel.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
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
                    Text(
                      'For People who want to [ see and search parties of other cities ], [Start chat - free for females] .',
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
                    CarouselSlider(
                      items: [
                        GestureDetector(
                          onTap: (){
                            selectPlanBottom(context: context,name:  controller.subscriptionModel.subsData![0].name , amount:controller.subscriptionModel.subsData![0].amount );
                          },
                          child: subscriptionPlansView(
                              subscriptionData:
                                  controller.subscriptionModel.subsData![0]),
                        ),
                        subscriptionPlansView(
                            subscriptionData:
                                controller.subscriptionModel.subsData![1]),
                        subscriptionPlansView(
                            subscriptionData:
                                controller.subscriptionModel.subsData![2]),

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
                        height: Get.height * 0.7,
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
          }),
    );
  }

  Widget subscriptionPlansView({required SubscriptionData? subscriptionData}) {
    return Stack(children: [
      FittedBox(
        child: Container(
          margin: EdgeInsets.all(6.0),
          width: Get.width * .8,
          height: Get.height * 0.68,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            // boxShadow: [BoxShadow(color: Colors.white,blurRadius: 2,spreadRadius: 2,offset:Offset.fromDirection(1.0),blurStyle:BlurStyle.inner  )],
                color: Colors.white
           /*    gradient: RadialGradient(
              center: Alignment(1, -0.45),
          radius: 0.9,
          colors: [
           Color(0xff7e160a),
            Color(0xff2e0303),
           //
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
        ),*/

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
                      fontSize: 35,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700),
                )),
                Center(
                  child: CircleAvatar(radius: 50,
                      backgroundColor: Color(0xff7e160a),
                      child: FittedBox(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                    '₹${subscriptionData?.amount}',
                    style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                  ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Container(
                      // color: Colors.red.shade900,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      width: Get.width * 0.75,
                      height: Get.width * 0.55,
                      child: Text(subscriptionData?.description ?? "",
                          maxLines: 8,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600))),
                ),
              ]),
        ),
      ),
      Positioned(
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
      ),
    ]);
  }

  void  selectPlanBottom({required BuildContext context , required String amount , required String name}){
     showModalBottomSheet(context: context, builder: (context)
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
            Container(
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
          ],
        ),
      );
    }
    );
  }
}
