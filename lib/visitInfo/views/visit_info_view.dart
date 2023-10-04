import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:partypeopleindividual/visitInfo/controllers/visit_info_controller.dart';

import 'package:sizer/sizer.dart';
import 'package:blur/blur.dart';
import '../../individual_nearby_people_profile/view/individual_people_profile.dart';
import '../../individual_subscription/view/subscription_view.dart';
import '../model/visitinfo.dart';

class VisitInfoView extends StatefulWidget {
  const VisitInfoView({Key? key}) : super(key: key);

  @override
  State<VisitInfoView> createState() => _VisitInfoViewState();
}

class _VisitInfoViewState extends State<VisitInfoView> {
  //visitInfoController visit_info_controller = Get.put(visitInfoController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tabBarItem = TabBar(
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3.sp,
      labelColor: Colors.white,
      unselectedLabelColor: const Color(0xFFc4c4c4),
      tabs: [
        Tab(
          child: Text(
            'Visitors',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Tab(
          child: Text(
            'Visited',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Tab(
          child: Text(
            'Liked',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:
        AppBar(
          shape: Border(
            bottom: BorderSide(color: const Color(0xFFc4c4c4), width: 1.sp),
          ),
          backgroundColor: Colors.transparent,
          // Set the background color to transparent
          leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
            iconSize: 12.sp,
          ),
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            'Visit Info',
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
          bottom: tabBarItem,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.red.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.sp),
                  Text(
                    'Only shows visitors from the past month ',
                    style: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFFc4c4c4)),
                  ),
                  SizedBox(height: 10.sp),
                  GetBuilder<visitInfoController>(
                    init: visitInfoController(),
                    builder: (controller) {
                      //Iterable<Data>? visiterdata = controller.visiterdataModel.data?.reversed;
                      // List<Data>? dataList = visiterdata?.toList();

                      // type 1 is for visiter
                      String type = '1';
                      return controller.visiterdataModel.data != null
                          ? Expanded(
                              child: ProfileContainer(
                                  dataList:
                                      controller.visiterdataModel.data ?? [],
                                  type: type,))
                          : loder();
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.sp),
                  Text(
                    'Only shows visited people from the past month ',
                    style: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFFc4c4c4)),
                  ),
                  SizedBox(height: 10.sp),
                  GetBuilder<visitInfoController>(
                    init: visitInfoController(),
                    builder: (controller) {
                      //   Iterable<Data>? visiteddata = controller.visiteddataModel.data?.reversed;
                      //  List<Data>? dataList = visiteddata?.toList();
                      // type 1 is for visited
                      String type = '2';
                      return controller.visiteddataModel.data != null
                          ? Expanded(
                              child: ProfileContainer(
                              dataList: controller.visiteddataModel.data ?? [],
                              type: type,
                            ))
                          : loder();
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.sp),
                  Text(
                    'Only shows liked people from the past month ',
                    style: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFFc4c4c4)),
                  ),
                  SizedBox(height: 10.sp),
                  GetBuilder<visitInfoController>(
                    init: visitInfoController(),
                    builder: (controller) {
                      // Iterable<Data>? visiteddata = controller.likedataModel.data?.reversed;
                      //  List<Data>? dataList = visiteddata?.toList();
                      // type 1 is for visiter
                      String type = '3';
                      return controller.likedataModel.data != null
                          ? Expanded(
                              child: ProfileContainer(
                              dataList: controller.likedataModel.data ?? [],
                              type: type,
                            ))
                          : loder();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
   Widget loder()
   {
     return Center(
       child: Container(
         child: Column(children: [
           Lottie.network(
               'https://assets-v2.lottiefiles.com/a/ebf552bc-1177-11ee-8524-57b09b2cd38d/PaP7jkQFk9.json')
         ]),
       )); }
}

class ProfileContainer extends StatelessWidget {
  String approvalStatus = GetStorage().read('approval_status');
  String newUser = GetStorage().read('newUser');
  String plan = GetStorage().read('plan_plan_expiry');
  String gender = GetStorage().read('myGender')??'Male';

  ProfileContainer({required this.dataList, required this.type});

  List<VisiterInfoData> dataList;
  String type;
  late VisiterInfoData data ;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.4,
      width: Get.width,
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
           data = dataList[index];
          var dateAndTime = data.date?.split(' ');
          String? time = dateAndTime?[1];
          String? date = dateAndTime?[0];
          return GestureDetector(
            onTap: () {
              log('user id ${data.userId}  ${dataList[index].userId}');
              if (getCondition() == 1) {
                Get.to(() => IndividualPeopleProfile(),
                    arguments: dataList[index].userId ?? "");
              } else {
                Get.to(SubscriptionView(
                  subText: 'Get complete access of visitors list and see who is interested in you ',
                  iconText:
                      'https://assets-v2.lottiefiles.com/a/dade640a-118b-11ee-bbfd-2b667fe34e14/wdWPPO8OuG.json',
                ));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    children: [
                      Blur(
                          blur:getCondition() == 1 ?0:5.0,

            child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Get.width * 0.5,
                                ),
                                child: CachedNetworkImage(
                                  height: Get.width * 0.12,
                                  width: Get.width * 0.12,
                                  imageUrl: data.profilePicture,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(Icons.person)),
                                ),
                              ),
                              Positioned(
                                bottom: 3.sp,
                                child: CircleAvatar(
                                  radius: 6.sp,
                                  backgroundImage: const NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                                  //const AssetImage('assets/images/indian_flag.png'),
                                ),
                              ),
                            ],
                          ),
                          overlay: getCondition() == 1
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        Get.width * 0.5,
                                      ),
                                      child: CachedNetworkImage(
                                        height: Get.width * 0.12,
                                        width: Get.width * 0.12,
                                        imageUrl: data.profilePicture,
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                child: Icon(Icons.person)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 3.sp,
                                      child: CircleAvatar(
                                        radius: 6.sp,
                                        backgroundImage: const NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                                        //const AssetImage('assets/images/indian_flag.png'),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()),
                      SizedBox(width: 12.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Blur(
                            blur:getCondition() == 1 ?0:5.0,
                            child: Text(
                              data.username ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF434343),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            overlay: getCondition() == 1
                                ? Text(
                                    data.username ?? '',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF434343),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : Container(),
                          ),
                          Text(
                            "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(date.toString()))}    ($time)",
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF434343),
                            ),
                          ),
                          /* Text(
                            "profilepic",
                            style: TextStyle(
                                fontSize: 8.sp, color: const Color(0xFFc4c4c4)),
                          ),
                          */
                        ],
                      ),
                    ],
                  ),
                ),
                /*   Container(
                color: const Color(0xFFc4c4c4),
                height: 0.4.sp,
                width: MediaQuery.of(context).size.width * 0.73,
              ),*/
              ],
            ),
          );
        },
      ),
    );
  }

  int getCondition() {
    int value = 0;

      if (type == '1' || type == '3') {
        if(gender =='Male') {
        if (newUser == '0') {
          if (plan == 'Yes') {
            value = 0;
          } else {
            value = 1;
          }
        } else {
          value = 1;
        }
      }
      else {
        value = 1;
      }
    }
    else{
      value = 1;
    }


    return value;
  }


}
