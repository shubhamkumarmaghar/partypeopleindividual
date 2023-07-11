import 'dart:convert';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List allParties = [];

  Future<void> getWishlistParty() async {
    final response = await http.post(
      Uri.parse('http://app.partypeople.in/v1/party/get_wish_list_party'),
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

  @override
  void initState() {
    getWishlistParty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: allParties.isEmpty
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
            : Stack(
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
                    itemCount: allParties.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Get.to(PartyPreview(
                          // data: allParties[index],
                          // isPopularParty: false,
                          // isHistory: true,
                          // ));
                        },
                        child: CustomListTile(
                          endTime: '${allParties[index]['end_time']}',
                          startTime: '${allParties[index]['start_time']}',
                          endDate: '${allParties[index]['end_date']}',
                          startDate: '${allParties[index]['start_date']}',
                          title: '${allParties[index]['title']}',
                          subtitle: '${allParties[index]['description']}',
                          trailingText: "Trailing Text",
                          leadingImage: '${allParties[index]['cover_photo']}',
                          leadingIcon: const Icon(Icons.history),
                          trailingIcon: const Icon(Icons.add),
                          city: '${allParties[index]['city_id']}',
                        ),
                      );
                    },
                  ),
                ],
              ));
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
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
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.08,
          right: MediaQuery.of(context).size.width * 0.08,
          bottom: MediaQuery.of(context).size.width * 0.07),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3c0103),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                    vertical: MediaQuery.of(context).size.height * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.length > 1
                          ? title[0].toUpperCase() + title.substring(1)
                          : title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFd3b2b1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0.sp,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: const Color(0xFFd3b2b1),
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
                  image: CachedNetworkImageProvider(leadingImage),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
