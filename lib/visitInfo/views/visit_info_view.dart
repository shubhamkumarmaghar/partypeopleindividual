import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/centralize_api.dart';
import 'package:partypeopleindividual/visitInfo/controllers/visit_info_controller.dart';
import 'package:partypeopleindividual/widgets/cached_image_placeholder.dart';
import 'package:sizer/sizer.dart';

import '../../individual_nearby_people_profile/view/individual_people_profile.dart';
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

    return   DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
                      return controller.visiterdataModel.data != null? Expanded(child: ProfileContainer(dataList:controller.visiterdataModel.data ??[],)):CircularProgressIndicator();
                    },),

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

                      return controller.visiteddataModel.data != null? Expanded(child: ProfileContainer(dataList:controller.visiteddataModel.data ??[],)):CircularProgressIndicator();
                    },),
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

                      return controller.likedataModel.data != null? Expanded(child: ProfileContainer(dataList:controller.likedataModel.data ??[],)):CircularProgressIndicator();
                    },),
                ],
              ),

            ],
          ),
        ),
      ),
    );

  }
}

class ProfileContainer extends StatelessWidget {
  ProfileContainer({
    required this.dataList
  });
  List<Data> dataList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height*0.4,
      width: Get.width,
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
           Data data = dataList[index];
           var dateAndTime = data.date?.split(' ');
           String? time = dateAndTime?[1];
           String? date = dateAndTime?[0];
        return GestureDetector(
          onTap: (){
            Get.to(()=>IndividualPeopleProfile(),arguments:data.userId??"" );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(15.sp),
                child: Row(
                  children: [
                     Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Get.width*0.5,),
                            child: CachedNetworkImage(height: Get.width*0.12,
                              width: Get.width*0.12,
                              imageUrl: data.profilePicture,
                              errorWidget: (context,url,error) => const CircleAvatar(child: Icon(Icons.person)),),
                          ),
                          Positioned(
                            bottom: 3.sp,
                            child: CircleAvatar(
                              radius: 6.sp,
                              backgroundImage:
                              const NetworkImage("https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                              //const AssetImage('assets/images/indian_flag.png'),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(width: 12.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         data.username ??'',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF434343),
                            fontWeight: FontWeight.w700,
                          ),
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
      },),
    );
  }
}
