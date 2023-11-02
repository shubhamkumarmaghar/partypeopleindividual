import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/ticketWidget.dart';

class JoinPartyDetails extends StatefulWidget {
  const JoinPartyDetails({super.key});

  @override
  State<JoinPartyDetails> createState() => _JoinPartyDetailsState();
}

class _JoinPartyDetailsState extends State<JoinPartyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.red.shade50,
       // appBar: AppBar(),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(1, -0.45),
            radius: 0.9,
            colors: [
              Color(0xffb80b0b),
              Color(0xff390202),
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
      //  margin: EdgeInsets.only(top:Get.width*0.1,left: 10,right: 10),
        child: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(
              height: Get.width*0.1,
            ),
            GestureDetector(onTap: (){Navigator.pop(context);},
              child: Container(
                  margin:EdgeInsets.only(left: 10),
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(child: Icon(Icons.arrow_back,color: Colors.red.shade900,),
                    backgroundColor: Colors.grey.shade200,)),
            ),
            SizedBox(
              height: Get.width*0.1,
            ),
          /*  Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),),
              shadowColor: Colors.red.shade800,
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                  Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text('Party Name',maxLines:2,style: TextStyle(fontSize: 25,
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w700),
                    ),
                          Text('01/10/2031',style: TextStyle(fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w700),
                          ),
                    ]
                    ),
                  ),
                  Text('Organization Name',style: TextStyle(fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                  ),
                  Text('Shubham Kumar',style: TextStyle(fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                  ),
                  Text('No of People : 6',style: TextStyle(fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                  ),
                  Text('Party Address : 137/b , c5 , KeshavPuram , Delhi , 311010',maxLines :3, style: TextStyle(fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                  ),
                      SizedBox(height: 20,),
                  Center(
                    child: Image.network('https://cdn.britannica.com/17/155017-050-9AC96FC8/Example-QR-code.jpg',
                      height: Get.height*0.2,
                    width: Get.height*0.2,),
                  ),
                      SizedBox(
                        height: 10,
                      ),
                ]),
              ),
            ),*/

                TicketWidget(
                width: Get.width*0.9, height: Get.height*0.7, child:
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.width*0.14,),
                      Container(alignment: Alignment.center,
                        child: Text('Shubham Kumar',textAlign: TextAlign.center,maxLines:2,style: TextStyle(fontSize: 18,
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image.network('https://cdn.britannica.com/17/155017-050-9AC96FC8/Example-QR-code.jpg',
                          height: Get.height*0.2,
                          width: Get.height*0.2,),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Text('Welcome Party',maxLines:2,style: TextStyle(fontSize: 25,
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text('Venue Name :     Organization Name',style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      Text('Party Time :         01/11/2023 , 10.00 PM',style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      Text('Party goes count :     6',style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      Text('Party Address :     137/b , c5 , KeshavPuram , Delhi , 311010',maxLines :3,
                        style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      Text('Coupon code :     Welcome500',textAlign: TextAlign.center,maxLines :3, style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      Text('Booked On :          01/11/2023',textAlign: TextAlign.center,maxLines :3, style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20,),

                    ]),
              ),isCornerRounded: true,),

          ],
        ),
      ),)
    );
  }
}
