import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/individualDashboard/controllers/individual_dashboard_controller.dart';
import 'package:sizer/sizer.dart';

import '../individualDashboard/models/party_model.dart';

class PartyCard extends StatefulWidget {
  final Function onTap;
  final Function onJoin;
  final Party party;

  PartyCard(
      {super.key,
      required this.onTap,
      required this.party,
      required this.onJoin});

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

  @override
  Widget build(BuildContext context) {
    if (widget.party == null) {
      return Center(
        child: Text('No Party Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            )),
      );
    } else {
      return GestureDetector(
        onTap: () {
          widget.onTap;
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.03,
                vertical: Get.width * 0.02,
              ),
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.width * 0.57,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.party.coverPhoto),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 5.sp),
                      height: Get.width * 0.19,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Column(children: [
                        SizedBox(
                          height: 4.sp,
                        ),
                        Row(
                          children: [
                            Text(
                              'TODAY - ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 7.sp,
                                  color: Colors.black),
                            ),
                            Text(
                              widget.party.id,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                  fontSize: 7.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.width * 0.008,
                        ),
                        Text(
                          widget.party.id,
                          style: TextStyle(
                              color: const Color(0xFF564d4d),
                              fontFamily: 'Poppins',
                              fontSize: 7.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.person_outlined,
                              size: 11.sp,
                            ),
                            SizedBox(
                              width: Get.width * 0.008,
                            ),
                            Text(
                              widget.party.id,
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 7.sp),
                            ),
                            SizedBox(
                              width: Get.width * 0.01,
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        widget.onJoin;
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: Get.width * 0.028),
                        height: MediaQuery.of(context).size.width * 0.052,
                        width: MediaQuery.of(context).size.width * 0.135,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.sp),
                          color: const Color(0xFFffa914),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.sp,
                            ),
                            Text(
                              'Join',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 10.sp),
                            ),
                            SizedBox(
                              width: 3.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, _) {
                          return IconButton(
                              icon: Icon(Icons.favorite,
                                  color: _colorAnimation.value,
                                  size: _sizeAnimation.value),
                              onPressed: () {
                                handleOnTap(widget.party);
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
