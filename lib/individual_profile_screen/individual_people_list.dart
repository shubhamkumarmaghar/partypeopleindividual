import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:like_button/like_button.dart';
import 'package:sizer/sizer.dart';

class peopleList extends StatefulWidget {
  const peopleList({super.key});

  @override
  State<peopleList> createState() => _peopleListState();
}

class _peopleListState extends State<peopleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
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
        child: CustomScrollView(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          slivers: [
        SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverToBoxAdapter(

              child: Container(
                height: Get.height*0.1,
              margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                homePageText(
                  "People List",
                  top: 30,
                  color: Colors.white
              ),
                GestureDetector(onTap: (){},
                  child:  Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 35),
                      child:  Image.asset("assets/images/filter.png",alignment: Alignment.centerLeft),
                    ),

                    homePageText(
                        "   Filter",
                        top: 30,
                        color: Colors.white
                    ),
                  ],),),


              ],
              ),

              ),

            ),

            SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.01,
                  ),
                  delegate: SliverChildBuilderDelegate(childCount: 40,
                      (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child:personGrid(),
                    );
                  }),
                )),
          ],
        ),

      ),
    );
  }

  Widget courseGrid() {
    return Container(
      padding: EdgeInsets.all(15.w),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/man.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Best Course for IT",
            textAlign: TextAlign.left,
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            "Flutter Best Courses",
            textAlign: TextAlign.left,
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }


  Widget homePageText(String text, {Color color = Colors.black, int top = 20}) {
    return Container(
      margin: EdgeInsets.only(top: top.sp),
      child: Text(
        text,
        style: TextStyle(
            color: color, fontSize: 14.sp,
            fontFamily: 'Poppins'),
      ),
    );
  }

  Widget personGrid(){
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery
            .of(context)
            .size
            .width * 0.015,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.005,
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
                  child: CircleAvatar(
                   // backgroundImage: NetworkImage(imageURL),
                    backgroundImage: AssetImage("assets/images/man.png"),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.01,
              ),
              Row(
                children: [
                  Icon(
                    Icons.message,
                    size: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.005,
                  ),
                  Text(
                    "shubham",
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

                //onTap: onLikeButtonTapped,
                circleColor: const CircleColor(
                    start: Colors.white, end: Color(0xFFe3661d)),
                size: Get.height * 0.022,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                   // color: likeStatus=='1' ? const Color(0xFFf9090a) : Colors.white,
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
       /*   Positioned(
            top: Get.height * 0.001,
            left: -Get.height * 0.001,
           child: onlineStatus=='on'? Container(
              width: Get.height * 0.032,
              height: Get.height * 0.032,
              padding: EdgeInsets.only(
                left: Get.height * 0.029,
                top: Get.height * 0.00045,
              ),
              child: Icon(
                Icons.circle,
                color:  Colors.green,
                size: Get.height * 0.016,
              ),
            ):Container(),
          ), */
        ],
      ),
    );
  }
}


