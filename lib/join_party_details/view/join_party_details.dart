import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../individual_book_party_report/model/book_party_list_model.dart';
import '../../widgets/ticketWidget.dart';
import '../controller/single_ticket_details_controller.dart';

class JoinPartyDetails extends StatefulWidget {
//  Data bookingPartyTicket;
   JoinPartyDetails({super.key,
     //required this.bookingPartyTicket
   });

  @override
  State<JoinPartyDetails> createState() => _JoinPartyDetailsState();
}

class _JoinPartyDetailsState extends State<JoinPartyDetails> {
  @override
  Widget build(BuildContext context) {
   // var data = widget.bookingPartyTicket;
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
        child: GetBuilder<BookSinglePartyTicketController>(
            init: BookSinglePartyTicketController(),
            builder: (controller) {
              var data = controller.partySingleBookingModel.data?[0];
              return controller.isLoading == false ?
              Column(
                children: [
                  SizedBox(
                    height: Get.width * 0.1,
                  ),
                  GestureDetector(onTap: () {
                    Navigator.pop(context);
                  },
                    child: Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.bottomLeft,
                        child: CircleAvatar(
                          child: Icon(Icons.arrow_back, color: Colors.red
                              .shade900,),
                          backgroundColor: Colors.grey.shade200,)),
                  ),
                  SizedBox(
                    height: Get.width * 0.1,
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
                  TicketWidget(pic: '${data?.coverPhoto}',
                    width: Get.width * 0.9,
                    height: Get.height * 0.7,
                    child:
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.width * 0.14,),
                            Container(alignment: Alignment.center,
                              child: Text(
                                '${data?.fullName}', textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(fontSize: 18,
                                    color: Colors.red.shade300,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Blur(blur:5.0 ,
                                child: Image.network(
                                  '${data?.qr}',
                                  height: Get.height * 0.2,
                                  width: Get.height * 0.2,),
                                overlay: partyDateChecker(data?.endDate?? '${DateTime.now()}')==true?Image.network(
                                  '${data?.qr}',
                                  height: Get.height * 0.2,
                                  width: Get.height * 0.2,):Container(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(alignment: Alignment.center,
                              child: Text('${data?.title}', maxLines: 2,
                                style: TextStyle(fontSize: 25,
                                    color: Colors.red.shade300,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            customText(text1:'Venue Name :    ',text2:  '${data?.organizationName}',fontSize: 14 ),
                            customText(text1:'Party Time :     ',text2: '${dateConvert(
                                '${data?.startDate}')}  ${data?.startTime.toString()}',fontSize: 14 ),
                            customText(text1:'Party goes count :   ',text2: '${data?.noOfPeople} ',fontSize: 14 ),
                            customText(text1:'Party Address :     ',text2: '${data?.latitude} ,${data?.longitude} ',fontSize: 14 ,maxLines: 3,),
                            customText(text1:'Coupon code :     ',text2: '${data?.discountDescription}',fontSize: 14 ),
                            customText(text1:'Booked On :       ',text2: '${dateConvert('${data?.createdAt}')} ',fontSize: 14 ),
                            SizedBox(height: 20,),

                          ]),
                    ),
                    isCornerRounded: true,),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      "✔ Ticket holder must be 18+ .\n"
                          "✔  Please carry your legal Identity card with you .\n"
                          "✔ All offers and discounts are posted by party hosts themself . ",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 11),
                    ),
                  ),
                ],
              ) : Center(child: CircularProgressIndicator.adaptive());
            }
        ),

      )
     /* Container(
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
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "✔ ticket holder must be 18+ .\n"
                    "✔  Please carry your legal id card with you .\n"
                    "✔ All offers and discounts are posted by pub themself . ",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 12),
              ),
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

                TicketWidget(pic: '${data.coverPhoto}',
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
                        child: Text('${data.fullName}',textAlign: TextAlign.center,maxLines:2,style: TextStyle(fontSize: 18,
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Blur(blur:5.0 ,
                          child: Image.network(
                            '${data.qr}',
                            height: Get.height * 0.2,
                            width: Get.height * 0.2,),
                          overlay:
                          partyDateChecker(data.endDate?? '${DateTime.now()}')==true?

                         Image.network(
                            '${data.qr}',
                            height: Get.height * 0.2,
                            width: Get.height * 0.2,):Text('Expired',style: TextStyle(fontSize: 26,color: Colors.red.shade900),),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        alignment: Alignment.center,
                        child: Text('${data.title.toString().capitalizeFirst}',maxLines:2,style: TextStyle(fontSize: 25,
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [  Text('Venue Name : ',style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      ),
                        Text('${data.organizationName}',maxLines: 2,style: TextStyle(fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        ),],),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Party Time :  ',style: TextStyle(fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          ),
                          Text('${dateConvert(data.startDate.toString())}  ${data.startTime.toString()}',
                            style: TextStyle(fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Party goes count :    ',style: TextStyle(fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: Get.width*0.4,
                            child: Text('${data.noOfPeople} People',style: TextStyle(fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Party Address : ',maxLines :3,
                            style: TextStyle(fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: Get.width*0.4,
                            child: Text(' ${data.latitude} ,${data.longitude} ,',
                              maxLines :3,
                              style: TextStyle(fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Coupon code : ',maxLines :3,
                            style: TextStyle(fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: Get.width*0.4,
                            child: Text('${data.discountDescription},',
                              maxLines :3,
                              style: TextStyle(fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Booked On :  ',textAlign: TextAlign.center,maxLines :3, style: TextStyle(fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: Get.width*0.4,
                            child: Text('${data.createdAt}',textAlign: TextAlign.start,maxLines :3, style: TextStyle(fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),

                    ]),
              ),
                  isCornerRounded: true,),

          ],
        ),
      ),)*/
    );
  }

  Widget customText({required String text1 ,required String text2 , Color color =Colors.black ,required double fontSize , int maxLines = 1})
  {
    return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$text1  ',style: TextStyle(fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.w600),
        ),
        SizedBox(width: Get.width*0.45,
          child: Text('$text2',style: TextStyle(fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
  String dateConvert(String date){
    String dateTime;
    if(date.isNotEmpty) {
      DateTime datee = DateTime.parse(date);
      dateTime = DateFormat('dd-MM-yyyy, ').format(datee);
    }
    else{
      dateTime='NA';
    }
    return dateTime;
  }
  bool partyDateChecker(String datetime){
    var time = datetime;
    DateTime datee = DateTime.parse(time);
    if(DateTime.now().isAfter(datee))
    {
      Fluttertoast.showToast(msg: 'This QR.is Expired,');
      return false;
    }
    else{
      return true;
    }

  }

}
