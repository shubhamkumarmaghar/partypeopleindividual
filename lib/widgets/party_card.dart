import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/individualDashboard/controllers/individual_dashboard_controller.dart';
import 'package:partypeopleindividual/individual_party_preview/party_preview_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../individualDashboard/models/party_model.dart';

class PartyCard extends StatefulWidget {
  final Party party;
  final String partyType;

  PartyCard({
    super.key,
    required this.party,
    required this.partyType,
  });

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard>
    with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.red).animate(_controller);
    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 24.0, end: 28.0),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 28.0, end: 24.0),
          weight: 50,
        ),
      ],
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> wishlistParty(String id) async {
    final response = await http.post(
      Uri.parse('http://app.partypeople.in/v1/party/add_to_wish_list_party'),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'party_id': id,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1) {
        print('Party Successfully added to wishlist');
        likeParty(id);


      } else {
        print('Failed to add party to wishlist');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add party to wishlist');
    }
  }

  Future<void> likeParty(String id) async {
    final response = await http.post(
      Uri.parse('http://app.partypeople.in/v1/party/party_like'),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'party_id': id,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1) {
        print('Party like save successfully');

      }
      else {
        print('Failed to like Party ');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to like Party');
    }
  }

  Future<void> viewParty(String id) async {
    final response = await http.post(
      Uri.parse('http://app.partypeople.in/v1/party/party_view'),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'party_id': id,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1) {
        print('Party view save successfully');

      }
      else {
        print('Failed to update view Party ');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update view Party');
    }
  }

  void handleOnTap(Party party) {
    IndividualDashboardController wishlistController = Get.find();

    if (wishlistController.wishlistedParties.contains(party)) {
      wishlistController.wishlistedParties.remove(party);

      Get.snackbar(
        'Party Removed',
        'This party has been removed from your wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } else {
      wishlistController.wishlistedParties.add(party);

      Get.snackbar(
        'Party Added',
        'This party has been added to your wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (widget.party.coverPhoto == '') {
      imageProvider = AssetImage('assets/images/default-cover-4.jpg');
    } else {
      imageProvider = NetworkImage(widget.party.coverPhoto);
    }

    return widget.partyType == 'popular'
        ? GestureDetector(
            onTap: () {
              viewParty(widget.party.id);
              Get.to(PartyPreview(party: widget.party));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                        vertical: Get.width * 0.02,
                      ),
                      width: MediaQuery.of(context).size.width * 0.82,
                      height: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.sp,
                            vertical: 5.sp,
                          ),
                          height: Get.width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.party.title!.capitalizeFirst!,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.visibility,
                                      size: 16, color: Colors.red),
                                  Text(
                                      "${widget.party.view} Views",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.thumb_up,
                                      size: 16, color: Colors.red),
                                  Text(
                                      "${widget.party.like} Likes",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.people, color: Colors.red),
                                  SizedBox(width: 5.sp),
                                  Text(
                                    "${widget.party.ongoing} Going",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              widget.partyType == 'upcoming'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Party Starts",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.sp),
                                      ],
                                    )
                                  : Text(
                                      widget.party.description.capitalizeFirst!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rating (4/5)",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SmoothStarRating(
                                        allowHalfRating: false,
                                        starCount: 5,
                                        rating: 4.00,
                                        size: 18.0,
                                        color: Colors.orange,
                                        borderColor: Colors.orange,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        spacing: .5,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('EEEE, MMMM d, yyyy, h:mm a')
                                        .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.party.startDate!) *
                                            1000,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Popular",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: isFavorite ? Colors.red : Colors.white,
                        onPressed: () {
                          setState(() {
                            isFavorite = true;
                          });
                          wishlistParty(widget.party.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Added to Wishlist'
                                    : 'Removed from Wishlist',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              viewParty(widget.party.id);
              Get.to(PartyPreview(party: widget.party));
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03,
                          vertical: Get.width * 0.02,
                        ),
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                            height: Get.width * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.party.title!.capitalizeFirst!,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                widget.partyType == 'upcoming'
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Party Starts",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 10.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                                    'EEEE, MMMM d, yyyy, h:mm a')
                                                .format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(widget.party
                                                              .startDate!) *
                                                          1000),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 9.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        widget
                                            .party.description.capitalizeFirst!,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10.sp,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rating (4/5)",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: 4.00,
                                      size: 18.0,
                                      color: Colors.orange,
                                      borderColor: Colors.orange,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      spacing: .5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: isFavorite ? Colors.red : Colors.white,
                          onPressed: () {
                            setState(() {
                              isFavorite = true;
                            });
                            // Call your function to process the favorite status
                            wishlistParty(widget.party.id);

                            // Show SnackBar with feedback message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? 'Added to Wishlist'
                                      : 'Removed from Wishlist',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          );
  }
}
