import 'dart:convert';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/wishlist_screen/controller/wisshlist_controller.dart';
import 'package:sizer/sizer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
 // List allParties = [];

 // WishlistController wishlistController = Get.put(WishlistController());
  /*Future<void> getWishlistParty() async {
    final response = await http.post(
      Uri.parse('https://app.partypeople.in/v1/party/get_wish_list_party'),
      headers: <String, String>{
        'x-access-token': GetStorage().read('token'),
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        print('Fetched wishlist parties successfully');
        print(jsonResponse); // Print the fetched data
        setState(() {
          allParties = jsonResponse['data'];
        });
      } else {
        print('Failed to fetch wishlist parties');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch wishlist parties');
    }
  }
*/
  @override
  void initState() {
   // wishlistController.getWishlistParty();
    super.initState();
  }
/*
  Future<void> deleteWishListParty(partyID) async {
    // API endpoint URL
    String url = 'https://app.partypeople.in/v1/party/delete_to_wish_list_party';

    // Request headers
    Map<String, String> headers = {
      'x-access-token': '${GetStorage().read('token')}',
    };

    // Request body
    Map<String, dynamic> body = {
      'party_id': partyID,
    };

    try {
      // Send POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print(response.body);
      // Check response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Party successfully removed from wish list');
      } else {
        // Request failed
        print(
            'Failed to remove party from wish list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error occurred while deleting wish list party: $e');
    }
    getWishlistParty();
  }
*/
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
            title: Text("Wishlist",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
            ),
        ),
        body: GetBuilder<WishlistController>(
          init: WishlistController(),
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
                child:  controller.allParties.isEmpty
                ? Center(
              child: Text(
                'No Wishlist Items Found',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Stack(
                children: [
                  Container(
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
                  ),
                  ListView.builder(
                    itemCount: controller.allParties.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: const ValueKey(0),
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (value) {
                                print(
                                    "Deleted party : ${controller.allParties[index]['party_id']}");
                                controller.deleteWishListParty(
                                    controller.allParties[index]['party_id']);
                              },
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: GestureDetector(

                          onTap: () {
                            // Get.to(PartyPreview(
                            // data: allParties[index],
                            // isPopularParty: false,
                            // isHistory: true,
                            // ));
                          },
                          child: CustomListTile(
                            endTime: '${controller.allParties[index]['end_time']}',
                            startTime: '${controller.allParties[index]['start_time']}',
                            endDate: '${controller.allParties[index]['end_date']}',
                            startDate: '${controller.allParties[index]['start_date']}',
                            title: controller.allParties[index]['title'] == null
                                ? 'Title'
                                : '${controller.allParties[index]['title']}',
                            subtitle: '${controller.allParties[index]['description']}',
                            trailingText: "Trailing Text",
                            leadingImage:
                            '${controller.allParties[index]['cover_photo']}',
                            leadingIcon: const Icon(Icons.history),
                            trailingIcon: const Icon(Icons.add),
                            city: '${controller.allParties[index]['city_id']}',
                          ),
                        ),

                      );
                        //CustomSlider( allParties: controller.allParties , index:  index);

                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 85),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Swipe left to remove the party from the wishlist.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9.sp,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Total Wishlist Parties ( ${controller.allParties.length} )",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ));
          }
        ));
  }
}
/*
class CustomSlider extends StatelessWidget{
  final List allParties;
  final int index;
  CustomSlider( {required this.allParties , required this.index});

  WishlistController wishlistController = Get.find();
  @override
  Widget build(BuildContext context) {
    return
      ;
  }

}
*/

class CustomListTile extends StatelessWidget {
  late final String title;
  final String subtitle;
  final String leadingImage;
  final String trailingText;
  final String startTime; // new field for start time
  final String endTime; // new field for end time
  final Widget leadingIcon;
  final String startDate;
  final String endDate;
  final Widget trailingIcon;
  final String city;

  CustomListTile({
    required this.title,
    required this.startTime, // pass start time to constructor
    required this.endTime, // pass end time to constructor

    required this.subtitle,
    required this.leadingImage,
    required this.startDate,
    required this.endDate,
    required this.trailingText,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (leadingImage == '') {
      imageProvider = AssetImage('assets/images/default-cover-4.jpg');
    } else {
      imageProvider = NetworkImage(leadingImage);
    }

    return FittedBox(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.08,
            right: MediaQuery.of(context).size.width * 0.08,
            bottom: MediaQuery.of(context).size.width * 0.07),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
           // color: Colors.white,
            boxShadow: [
              const BoxShadow(
                color: Color.fromARGB(255, 110, 19, 9),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(margin: EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width*0.5,
                      child: Text(
                        title.length > 1
                            ? title[0].toUpperCase() + title.substring(1)
                            : title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF3c0103),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: const Color(0xFF3c0103),
                          size: 13.sp,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.015,
                        ),
                        Text(
                          "${startDate} $startTime\n${endDate} $endTime",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.12,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
