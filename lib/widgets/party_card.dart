import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/individualDashboard/controllers/individual_dashboard_controller.dart';

import 'package:sizer/sizer.dart';

import '../centralize_api.dart';
import '../firebase_custom_event.dart';
import '../individualDashboard/models/party_model.dart';
import '../individual_party_preview/party_preview_screen_new.dart';
import '../join_party_details/view/join_party_details.dart';

class PartyCard extends StatefulWidget {
  final Party party;
  final String partyType;
  final Function onBack;

  PartyCard({
    super.key,
    required this.party,
    required this.onBack,
    required this.partyType,
  });

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard>
    with SingleTickerProviderStateMixin {
  late ConfettiController _controllerBottomCenter;
  String approvalStatus = GetStorage().read('approval_status') ?? '0';
  String newUser = GetStorage().read('newUser') ?? '0';
  String plan = GetStorage().read('plan_plan_expiry') ?? 'Yes';
  bool isFavorited = false;
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;
  String join = 'Book Now';
  int noOfPeople = 2;
  IndividualDashboardController wishlistController = Get.find();

  @override
  void initState() {
    //logCustomEvent(eventName: partyPreview, parameters: {'name':'Party preview'});
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.red).animate(_controller);
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
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
      Uri.parse(API.addToWishList),
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
      Uri.parse(API.partyLike),
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
        Get.find<IndividualDashboardController>().animateHeart();
        Get.find<IndividualDashboardController>().update();
      } else {
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
      Uri.parse(API.partyView),
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
      if (jsonResponse['status'] == 0) {
        print('Party view already viewed');
      } else {
        print('Failed to update view Party ');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update view Party');
    }
  }

  void handleOnTap(Party party) {

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
              if (approvalStatus == '1') {
                Get.to(PartyPreviewScreen(party: widget.party))
                    ?.then((value) => widget.onBack());
              } else {
                Get.snackbar('Sorry!',
                    'Your account is not approved , please wait until it got approved');
              }
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
                      width: MediaQuery.of(context).size.width * 0.85,
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
                          height: Get.width * 0.355,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Container(
                                      width: Get.width * 0.65,
                                      child: Row(
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.57),
                                            child: Text(
                                              widget
                                                  .party.title.capitalizeFirst!,
                                              maxLines: 2,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'Poppins',
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          widget.party.orgBluetickStatus == '1'
                                              ? Icon(
                                                  Icons.verified,
                                                  color: Colors.blueAccent,
                                                  size: 18,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ratingView(
                                      rating: '${widget.party.orgRatings}'),
                                ],
                              ),
                              Expanded(
                                child: Row(
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
                                  : FittedBox(
                                      child: Container(
                                        width: Get.width * 0.81,
                                        child: Text(
                                          widget.party.description
                                              .capitalizeFirst!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10.sp,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                              Text(
                                DateFormat('d MMMM, yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.party.startDate) *
                                              1000),
                                    ) +
                                    '  ${widget.party.startTime}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.party.discountAmount != '0'
                                            ? Text(
                                          widget.party.discountType == '1'
                                              ? 'Get ${widget.party.discountAmount}% off ${widget.party.billMaxAmount != '0' ? 'upto ₹${widget.party.billMaxAmount}' : ""} .'
                                              : 'Get flat ₹${widget.party.discountAmount} off ${widget.party.billMaxAmount != '0' ? 'on minimum ₹${widget.party.billMaxAmount}' : ""} .',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ): Container(),
                                        bookNowButton()
                                    /*    GestureDetector(
                                          onTap: () async {
                                            _controllerBottomCenter.play();
                                            var data =
                                                await APIService.ongoingParty(
                                                    widget.party.id);

                                            if (data == true) {
                                              setState(() {});
                                              _controllerBottomCenter.play();
                                              join = 'Joined';
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.orange,
                                            ),
                                            width: Get.width * 0.2,
                                            height: Get.height * 0.031,
                                            padding: EdgeInsets.all(5),
                                            child: FittedBox(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        CupertinoIcons
                                                            .add_circled,
                                                        color: Colors.white),
                                                    widget.party.ongoingStatus ==
                                                            0
                                                        ? Text(
                                                            join,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          )
                                                        : Text(
                                                            "Joined",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          )
                                                  ]),
                                            ),
                                          ),
                                        )
                                        */
                                      ],
                                    )
                                  ,
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
                          color: Colors.red.shade900,
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
                        child: widget.party.likeStatus == 0
                            ? IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color: isFavorite
                                    ? Colors.red.shade900
                                    : Colors.white,
                                onPressed: () {
                                  if (approvalStatus == '1') {
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
                                  } else {
                                    Get.snackbar('Sorry!',
                                        'Your account is not approved , please wait until it got approved');
                                  }
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.favorite),
                                color: Colors.red.shade900,
                                onPressed: () {},
                              )),
                    Positioned(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _controllerBottomCenter,
                          blastDirection: -pi / 2,
                          emissionFrequency: 0.01,
                          numberOfParticles: 20,
                          maxBlastForce: 100,
                          minBlastForce: 80,
                          gravity: 0.3,
                          blastDirectionality: BlastDirectionality.explosive,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              viewParty(widget.party.id);
              if (approvalStatus == '1') {
                //  Get.to(PartyPreview(party: widget.party))?.then((value) => widget.onBack());
                Get.to(PartyPreviewScreen(party: widget.party))
                    ?.then((value) => widget.onBack());
              } else {
                Get.snackbar('Sorry!',
                    'Your account is not approved , please wait until it got approved');
              }
            },
            child: FittedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.party.title.capitalizeFirst!,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        widget.party.orgBluetickStatus == '1'
                                            ? Icon(
                                                Icons.verified,
                                                color: Colors.blueAccent,
                                                size: 18,
                                              )
                                            : Container(),
                                      ],
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
                                              DateFormat('EEEE, MMMM d, yyyy')
                                                      .format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(widget
                                                                    .party
                                                                    .startDate) *
                                                                1000),
                                                  ) +
                                                  '  ${widget.party.startTime}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 9.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.party.description
                                                  .capitalizeFirst!,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10.sp,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Party Time : ${widget.party.startTime}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),

                                  /*
                               Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rating (${widget.party.orgRatings} /5.0)",
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
                                        rating: double.parse(
                                            widget.party.orgRatings),
                                        size: 18.0,
                                        color: Colors.orange,
                                        borderColor: Colors.orange,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        spacing: .5,
                                      ),
                                    ],
                                  ),*/

                                  ratingView(
                                      rating: '${widget.party.orgRatings}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        /* Positioned(
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
                        ), */
                        widget.party.offers == 'free' ||
                                widget.party.discountAmount == '0'
                            ? Container()
                            : Positioned(
                                top: 8.0,
                                left: 8.0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    widget.party.discountType == '1'
                                        ? '${widget.party.discountAmount}% off'
                                        : 'Flat ${widget.party.discountAmount} off',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                        Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: widget.party.likeStatus == 0
                                ? IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    color: isFavorite
                                        ? Colors.red.shade900
                                        : Colors.white,
                                    onPressed: () {
                                      logCustomEvent(eventName: partyLike, parameters: {'name':'Party Like'});
                                      if (approvalStatus == '1') {
                                        setState(() {
                                          isFavorite = true;
                                        });
                                        wishlistParty(widget.party.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isFavorite
                                                  ? 'Added to Wishlist'
                                                  : 'Removed from Wishlist',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        Get.snackbar('Sorry!',
                                            'Your account is not approved , please wait until it got approved');
                                      }
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.favorite),
                                    color: Colors.red.shade900,
                                    onPressed: () {},
                                  )),
                      ],
                    ),
                  )),
            ),
          );
  }

  Widget ratingView({required String rating}) {
    return Container(
      width: Get.width * 0.13,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.green.shade800),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ' $rating ',
            style: TextStyle(
              // fontFamily: 'Poppins',
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            CupertinoIcons.star_fill,
            size: 13,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  joinPartyFormDialouge({required BuildContext context}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*   TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter any text";
                        },
                        decoration:
                        InputDecoration(hintText: "Please Enter Text"),
                      ),*/
                  /*   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choice Box"),
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked;
                                });
                              })
                        ],
                      )*/
                  Center(
                    child: Text(
                      '${widget.party.title.capitalizeFirst}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Text(
                    'Date : ${widget.party.prStartDate != null ? DateFormat('d MMMM, y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.party.startDate) * 1000)) : ''} ',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Text(
                    "Time: ${widget.party.startTime}  to  ${widget.party.endTime}",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'No of People : ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              noOfPeople--;
                              setState(
                                    () {},
                              );
                            },
                            child: Icon(CupertinoIcons.minus_circle_fill,
                                color: Colors.red.shade900),
                          ),
                          Text(
                            '  ${noOfPeople.toString()}  ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                              onTap: () {
                                noOfPeople++;
                                setState(
                                      () {},
                                );
                              },
                              child: Icon(CupertinoIcons.plus_circle_fill,
                                  color: Colors.red.shade900))
                        ],
                      )
                    ],
                  ),
                ],
              ),
              title: Container(padding:EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red.shade900),
                child: Text(
                  'Avail this Offer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp
                  ),
                ),
              ),
              actions: <Widget>[
                Center(
                  child: InkWell(
                    child:
                    Container(
                      // width: 50,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange),
                        child: Text(
                          '   Book Now   ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                    onTap: () async {
                      /*  if (_formKey.currentState.validate()) {
// Do something like updating SharedPreferences or User Settings etc.

                       */
                      String pj_id =   await APIService.onBookingParty(
                          widget.party.id, noOfPeople.toString());
                     // var data= APIService.ongoingParty(widget.party.id);
                      if(pj_id.isNotEmpty){
                        join = 'Booked';
                      }
                      Navigator.of(context).pop();
                      if(pj_id!=''){
                        Get.to(JoinPartyDetails(),arguments: pj_id);
                      }
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  Widget bookNowButton()
  {
    return GestureDetector(
      onTap: () async {
        logCustomEvent(eventName: bookNow, parameters: {'name':'book Now'});
if(wishlistController.individualProfileController.coverPhotoURL.isNotEmpty && wishlistController.individualProfileController.bio.isNotEmpty) {
  widget.party.ongoingStatus != 1 ?
  await joinPartyFormDialouge(context: context) :
  Fluttertoast.showToast(msg: 'You are already booked this offer',);
  setState(() {});
  join = 'Booked';
  _controllerBottomCenter.play();
}
else{
  Get.snackbar('Sorry',
      'Upload your profile photo & Bio to access all the features.');
}
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(20),
          color: Colors.orange,
        ),
        width: Get.width * 0.2,
        height: Get.height * 0.031,
        padding: EdgeInsets.all(5),
        child: FittedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.add_circled,
                    color: Colors.white),
                SizedBox(
                  width: Get.width * 0.003,
                ),
                widget.party.ongoingStatus == 0
                    ? Text(
                  join,
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                )
                    : Text(
                  "Booked",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                )
              ]),
        ),
      ),
    );
  }
}
