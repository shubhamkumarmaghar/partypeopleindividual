import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:partypeopleindividual/chatScreen/views/chat_screen_view.dart';
import 'package:partypeopleindividual/individualDashboard/controllers/individual_dashboard_controller.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';
import 'package:sizer/sizer.dart';

import '../../individualDrawer/views/individual_drawer_view.dart';
import '../../individualNotificationScreen.dart';

class IndividualDashboardView extends StatefulWidget {
  const IndividualDashboardView({super.key});

  @override
  State<IndividualDashboardView> createState() =>
      _IndividualDashboardViewState();
}

class _IndividualDashboardViewState extends State<IndividualDashboardView> {
  IndividualDashboardController individualDashboardController =
      Get.put(IndividualDashboardController());
  IndividualProfileController individualProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.07,
          title: Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.to(
                IndividualDrawerView(),
                duration: const Duration(milliseconds: 500),
                transition: Transition.leftToRight,
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            Expanded(
              child: Obx(() {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${individualProfileController.username.value}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(
                      const IndividualNotificationScreen(),
                      duration: const Duration(milliseconds: 500),
                      transition: Transition.rightToLeft,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(
                      const IndividualNotificationScreen(),
                      duration: const Duration(milliseconds: 500),
                      transition: Transition.rightToLeft,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFffa914),
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          height: 70,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: const Color(0xFF5a0404),
          child: GNav(
            padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 6.sp),
            gap: 5,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFF802a2a),
            tabs: [
              const GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              const GButton(
                icon: Icons.search,
                text: 'Search',
                margin: EdgeInsets.only(right: 35),
              ),
              GButton(
                  icon: Icons.message,
                  text: 'Chat',
                  margin: const EdgeInsets.only(left: 45),
                  onPressed: () {
                    Get.to(
                      const ChatScreenView(),
                      duration: const Duration(milliseconds: 500),
                      transition: Transition.downToUp,
                    );
                  }),
              const GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              Container(
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
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.065),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.1,
                        ),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.sp)),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Search user by username',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11.sp,
                                          fontFamily: 'Poppins')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.27,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.05),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              individualDashboardController.allCityList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () {},
                                child: CityCard(
                                  cityName: individualDashboardController
                                      .allCityList[index].name,
                                  imageURL: individualDashboardController
                                      .allCityList[index].imageUrl,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: Text(
                          'People Nearby',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 135, 19, 19),
                              Color(0xFF711b1b),
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.width * 0.27,
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () {},
                                child: const NearbyPeopleProfile(),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: Get.height * 0.005,
                        ),
                        child: Text(
                          'Popular Events in Delhi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return PartyCard(
                                onTap: () {},
                                assetPath: 'assets/images/default-cover-4.jpg',
                                eventTime: '20:09',
                                eventDescription: 'Very GOood Partyy',
                                participantCount: '21312',
                                onJoin: () {});
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'TODAY (${individualDashboardController.lengthOfTodayParties})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return PartyCard(
                                onTap: () {},
                                assetPath: 'assets/images/default-cover-4.jpg',
                                eventTime: '20:09',
                                eventDescription: 'Very GOood Partyy',
                                participantCount: '21312',
                                onJoin: () {});
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'TOMORROW (${individualDashboardController.lengthOfTommParties})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return PartyCard(
                                onTap: () {},
                                assetPath: 'assets/images/default-cover-4.jpg',
                                eventTime: '20:09',
                                eventDescription: 'Very Good Party',
                                participantCount: '21312',
                                onJoin: () {});
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'UPCOMING (${individualDashboardController.lengthOfUpcomingParties})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: individualDashboardController
                              .lengthOfUpcomingParties.value,
                          itemBuilder: (context, index) {
                            return PartyCard(
                                onTap: () {},
                                assetPath: 'assets/images/default-cover-4.jpg',
                                eventTime: '20:09',
                                eventDescription: 'Very GOood Partyy',
                                participantCount: '21312',
                                onJoin: () {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  String imageURL;
  String cityName;

  CityCard({
    super.key,
    required this.imageURL,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(Get.width * 0.0045),
            decoration: BoxDecoration(
                border: Border.all(
                  width: Get.width * 0.004,
                  color: const Color(0xFFf69416),
                ),
                borderRadius: BorderRadius.circular(100.sp),
                color: Colors.white),
            child: CircleAvatar(
              radius: Get.width * 0.067,
              backgroundImage: NetworkImage(
                'http://app.partypeople.in/$imageURL',
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.02,
          ),
          Text(
            '$cityName',
            style: TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}

class NearbyPeopleProfile extends StatelessWidget {
  const NearbyPeopleProfile({
    super.key,
  });

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.015,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
              Container(
                width: Get.width * 0.151,
                height: Get.width * 0.151,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: Get.width * 0.005,
                    color: const Color(0xFFe3661d),
                  ),

                  borderRadius: BorderRadius.circular(100.sp), //<-- SEE HERE
                ),
                child: Padding(
                  padding: EdgeInsets.all(Get.width * 0.006),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/img.png'),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  Icon(
                    Icons.message,
                    size: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 10.sp),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: Get.height * 0.001,
            right: -Get.height * 0.006,
            child: Container(
              width: Get.height * 0.032,
              height: Get.height * 0.032,
              padding: EdgeInsets.only(
                left: Get.height * 0.0045,
                top: Get.height * 0.00045,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100.sp),
              ),
              child: LikeButton(
                onTap: onLikeButtonTapped,
                circleColor: const CircleColor(
                    start: Colors.white, end: Color(0xFFe3661d)),
                size: Get.height * 0.022,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: isLiked ? const Color(0xFFf9090a) : Colors.white,
                    size: Get.height * 0.022,
                  );
                },
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Color(0xff0099cc),
                  dotSecondaryColor: Color(0xff0099cc),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceSelectionButton extends StatelessWidget {
  ChoiceSelectionButton(
      {super.key, required this.buttonState, required this.textVal});

  bool buttonState;
  final String textVal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
          horizontal: MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: buttonState == true ? Colors.white : const Color(0xFFa22d2d),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          textVal,
          style: TextStyle(
              color: buttonState == true ? Colors.black : Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              fontSize: 13.sp),
        ),
      ),
    );
  }
}

class PartyCard extends StatelessWidget {
  final Function onTap;
  final String assetPath;
  final String eventTime;
  final String eventDescription;
  final String participantCount;
  final Function onJoin;

  const PartyCard({
    super.key,
    required this.onTap,
    required this.assetPath,
    required this.eventTime,
    required this.eventDescription,
    required this.participantCount,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap;
      },
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
          width: MediaQuery.of(context).size.width * 0.38,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12.sp),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
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
                          eventTime,
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
                      eventDescription,
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
                          participantCount,
                          style:
                              TextStyle(fontFamily: 'Poppins', fontSize: 7.sp),
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
                    onJoin;
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
