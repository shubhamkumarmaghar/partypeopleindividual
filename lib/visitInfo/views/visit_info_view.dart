import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VisitInfoView extends StatefulWidget {
  const VisitInfoView({Key? key}) : super(key: key);

  @override
  State<VisitInfoView> createState() => _VisitInfoViewState();
}

class _VisitInfoViewState extends State<VisitInfoView> {
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

    var listItem = ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return const ProfileContainer(userName: 'Bennn', time: '09:09');
      },
    );

    return DefaultTabController(
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
                    'Only shows visitors from the past month',
                    style: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFFc4c4c4)),
                  ),
                  SizedBox(height: 10.sp),
                  Expanded(child: listItem),
                ],
              ),
              listItem,
              listItem,
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    required this.userName,
    required this.time,
  });

  final String userName;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.sp,
                backgroundImage: const AssetImage("assets/img.png"),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 3.sp,
                      child: CircleAvatar(
                        radius: 6.sp,
                        backgroundImage:
                            const AssetImage('assets/indian_flag.png'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.sp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF434343),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'DUMMY TEXT',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: const Color(0xFF434343),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 8.sp, color: const Color(0xFFc4c4c4)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: const Color(0xFFc4c4c4),
          height: 0.4.sp,
          width: MediaQuery.of(context).size.width * 0.73,
        ),
      ],
    );
  }
}
