import 'dart:convert';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:partypeopleindividual/individualDashboard/controllers/individual_dashboard_controller.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';
import 'package:partypeopleindividual/notification/notification_screen.dart';
import 'package:partypeopleindividual/wishlist_screen/wishlist_screen.dart';
import 'package:sizer/sizer.dart';

import '../../individualDrawer/views/individual_drawer_view.dart';
import '../../individual_nearby_people_profile/view/individual_people_list.dart';
import '../../individual_nearby_people_profile/view/individual_people_profile.dart';
import '../../individual_profile_screen/individual_profile_screen.dart';
import '../../individual_profile_screen/individual_profile_screen_view.dart';
import '../../widgets/party_card.dart';
import 'nearby_people_profile.dart';

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
  int _selectedIndex = 1; // Initial

  @override
  void initState() {
     _selectedIndex = 1;
    super.initState();


  } // selected index

  @override
  Widget build(BuildContext context) {
    _selectedIndex = 1;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: MediaQuery
              .of(context)
              .size
              .height * 0.07,
          actions: [
            Container(
              padding: const EdgeInsets.only(left: 14),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () =>
                    Get.to(
                      IndividualDrawerView(),
                      duration: const Duration(milliseconds: 500),
                      transition: Transition.leftToRight,
                    )?.then((value) =>individualDashboardController.getDataForDashboard()),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
      // get status for privacy and notification

      if(individualProfileController.privacyOnlineStatus.value.toString() =='No')
      {
        GetStorage().write("privacy_online_status", true);
      }
      else{
        GetStorage().write("privacy_online_status", false);
      }
      print("privacy_online_status   ${ GetStorage().read("privacy_online_status")}  ${individualProfileController.privacyOnlineStatus.value}");
      if(individualProfileController.notification.value =='off')
      {
        GetStorage().write("online_notification_status", false);
      }
      else{
        GetStorage().write("online_notification_status", true);
      }

      print("online_notification_status   ${ GetStorage().read("online_notification_status")}   ${individualProfileController.notification.value}");

                return Container(
                  alignment: Alignment.center,
                  child: Text("          "+
                    individualProfileController.username.value,
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


                  Obx(() {
                    IndividualDashboardController wishlistController =
                    Get.find();
                    return GestureDetector(
                      onTap: () {
                        Get.to(const WishlistScreen())?.then((value) =>individualDashboardController.getDataForDashboard());
                      },
                      child: Icon(Icons.favorite,
                          color: wishlistController.wishlistedParties.isEmpty
                              ? Colors.white
                              : Colors.red),
                    );
                  }
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Get.to(
                          const NotificationScreen(),
                          duration: const Duration(milliseconds: 300),
                          transition: Transition.rightToLeft,
                        )?.then((value) =>individualDashboardController.getDataForDashboard()),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        extendBody: false,
        bottomNavigationBar: BottomAppBar(
          height: 70,
          shape: const CircularNotchedRectangle(),
          color: const Color(0xFF5a0404),
          child: GNav(
            selectedIndex: _selectedIndex,
            // Pass the selected index variable
            onTabChange: (index) {
              // Handle tab change event
              setState(() {
                _selectedIndex = index;
                if (_selectedIndex == 2) {
                //  Get.to(IndividualProfileScreen())?.then((value) =>individualDashboardController.getDataForDashboard());
                  Get.to(IndividualProfileScreenView())?.then((value) =>individualDashboardController.getDataForDashboard());
                }
              });
            },
            padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 6.sp),
            gap: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFF802a2a),
            tabs: const [
              GButton(
                icon: Icons.search,
                text: 'Search',
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                iconSize: 24,
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                iconSize: 24,
              ),
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
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.065),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // search bar
                      Container(
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.1,
                        ),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.sp)),
                                child: TextField(
                                  onTap:(){
                                    Get.to(PeopleList(peopleList:individualDashboardController
                                        .usersList ,))?.then((value) =>individualDashboardController.getDataForDashboard());
                                  },
                                  readOnly: true,
                                //  enabled: false,
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

                      // get all cities
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.27,
                        margin: EdgeInsets.only(
                            top: MediaQuery
                                .of(context)
                                .size
                                .height * 0.02,
                            left: MediaQuery
                                .of(context)
                                .size
                                .width * 0.05),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                          individualDashboardController.allCityList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) =>
                              GestureDetector(
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

                      // people nearby
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery
                                .of(context)
                                .size
                                .width * 0.05,
                            right: MediaQuery
                                .of(context)
                                .size
                                .width * 0.05,
                            bottom: MediaQuery
                                .of(context)
                                .size
                                .height * 0.01),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(
                          'People Nearby (${individualDashboardController
                              .usersList.length})',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                          GestureDetector(onTap:(){
                            Get.to(PeopleList(peopleList:individualDashboardController
                                .usersList ,))?.then((value) =>individualDashboardController.getDataForDashboard());
                            },
                            child:  Text(
                              'See all ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                         ,
                          ],
                        ),

                      ),
                      individualDashboardController
                          .noUserFoundController.value ==
                          'null'
                          ? Container(
                    /*    decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 135, 19, 19),
                              Color(0xFF711b1b),
                            ],
                          ),
                        ), */
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.3,
                        padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: individualDashboardController
                              .usersList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) =>
                              GestureDetector(
                                onTap: () {
                                  //PeopleViewed(individualDashboardController.usersList[index].id);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualPeopleProfile(),));
                                 Get.to(()=>IndividualPeopleProfile(user_id: individualDashboardController.usersList[index].id,))?.then((value) =>individualDashboardController.getDataForDashboard());
                                },
                                child: NearByPeopleProfile(
                                  imageURL: individualDashboardController.usersList[index].profilePicture,
                                  name: individualDashboardController.usersList[index].username,
                                  id: individualDashboardController.usersList[index].id,
                                  likeStatus: individualDashboardController.usersList[index].likeStatus,
                                  onlineStatus: individualDashboardController.usersList[index].onlineStatus,
                                  privacyStatus: individualDashboardController.usersList[index].privacyOnline,
                                ),
                              )),
                        ),
                      )
                          : const Center(
                        child: Text("No Peoples Around You"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
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
                      individualDashboardController.jsonPartyPopularData.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No Party Available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  // Deep purple color for the text
                                  fontFamily: 'Poppins', // Custom font
                                ),
                              ),
                              Text(
                                'Check back later for updates.',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  // Lighter purple color for the text
                                  fontFamily: 'Raleway', // Custom font
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: individualDashboardController
                              .lengthOfPopularParties.value,
                          itemBuilder: (context, index) {
                            return PartyCard(
                                party: individualDashboardController
                                    .jsonPartyPopularData[index],
                                onBack: ()=>individualDashboardController.getDataForDashboard(),
                                partyType: 'popular');
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'TODAY (${individualDashboardController
                              .lengthOfTodayParties})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      individualDashboardController
                          .jsonPartyOrganisationDataToday.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No Party Available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  // Deep purple color for the text
                                  fontFamily: 'Poppins', // Custom font
                                ),
                              ),
                              Text(
                                'Check back later for updates.',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  // Lighter purple color for the text
                                  fontFamily: 'Raleway', // Custom font
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: individualDashboardController
                              .jsonPartyOrganisationDataToday.length,
                          itemBuilder: (context, index) {
                            return PartyCard(
                              party: individualDashboardController
                                  .jsonPartyOrganisationDataToday[index],
                              onBack: ()=>individualDashboardController.getDataForDashboard(),
                              partyType: 'today',
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'TOMORROW (${individualDashboardController
                              .jsonPartyOrganisationDataTomm.length})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      individualDashboardController
                          .jsonPartyOrganisationDataTomm.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No Party Available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  // Deep purple color for the text
                                  fontFamily: 'Poppins', // Custom font
                                ),
                              ),
                              Text(
                                'Check back later for updates.',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  // Lighter purple color for the text
                                  fontFamily: 'Raleway', // Custom font
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: individualDashboardController
                              .jsonPartyOrganisationDataTomm.length,
                          itemBuilder: (context, index) {
                            return PartyCard(
                              party: individualDashboardController
                                  .jsonPartyOrganisationDataTomm[index],
                              onBack: ()=>individualDashboardController.getDataForDashboard(),
                              partyType: 'tommorow',
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          top: Get.height * 0.003,
                        ),
                        child: Text(
                          'UPCOMING (${individualDashboardController
                              .jsonPartyOgranisationDataUpcomming.length})',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      individualDashboardController
                          .jsonPartyOgranisationDataUpcomming.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No Party Available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  // Deep purple color for the text
                                  fontFamily: 'Poppins', // Custom font
                                ),
                              ),
                              Text(
                                'Check back later for updates.',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  // Lighter purple color for the text
                                  fontFamily: 'Raleway', // Custom font
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(
                          top: Get.width * 0.05,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          bottom: Get.width * 0.05,
                        ),
                        height: Get.width * 0.65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: individualDashboardController
                              .jsonPartyOgranisationDataUpcomming.length,
                          itemBuilder: (context, index) {
                            return PartyCard(
                              party: individualDashboardController
                                  .jsonPartyOgranisationDataUpcomming[
                              index],
                              onBack: ()=>individualDashboardController.getDataForDashboard(),
                              partyType: 'upcoming',
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
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
        MediaQuery
            .of(context)
            .size
            .width * 0.015,
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
            height: MediaQuery
                .of(context)
                .size
                .width * 0.02,
          ),
          Text(
            cityName,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 10.sp),
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
      width: MediaQuery
          .of(context)
          .size
          .width * 0.35,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery
              .of(context)
              .size
              .height * 0.01,
          horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.02),
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

class PopularPartyCard extends StatelessWidget {
  final Function onTap;
  final String assetPath;
  final String eventTime;
  final String eventDescription;
  final String participantCount;
  final Function onJoin;

  PopularPartyCard({
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.57,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.50,
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
                      onJoin;
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: Get.width * 0.028),
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * 0.052,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.135,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.sp),
                        color: const Color(0xFFffa914),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CupertinoIcons.add_circled,
                            color: Colors.white,
                            size: 15,
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
      ),
    );
  }
}
