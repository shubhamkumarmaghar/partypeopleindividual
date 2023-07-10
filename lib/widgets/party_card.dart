import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    return Padding(
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
            height: MediaQuery.of(context).size.width * 0.65,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.party.coverPhoto),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.maxFinite,
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
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
                        fontSize: 11.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Starts",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy, h:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.party.startDate!) * 1000),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ends",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy, h:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.party.endDate!) * 1000),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
