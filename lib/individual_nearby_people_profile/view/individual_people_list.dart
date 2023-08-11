import 'dart:async';
import 'dart:developer';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:like_button/like_button.dart';
import 'package:partypeopleindividual/individual_nearby_people_profile/controller/people_profile_controller.dart';
import 'package:sizer/sizer.dart';

import '../../individualDashboard/models/usermodel.dart';
import '../../individualDashboard/views/nearby_people_profile.dart';
import '../../individual_nearby_people_profile/view/individual_people_profile.dart';

class PeopleList extends StatefulWidget {
  final List<UserModel> peopleList;

   PeopleList({Key? key, required this.peopleList}) : super(key: key);

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  List<UserModel> maleList = [];
  List<UserModel> femaleList = [];
  List<UserModel> showList = [];
  List<UserModel> otherList = [];
  int choiceIndex = 0;
  Timer? _debounce;
  TextEditingController? _textEditingController ;

  void getMaleFemaleList() {
    widget.peopleList.forEach((element) {
      showList = widget.peopleList;
      if(element.gender=='Male'){
      maleList.add(element);
    }
      else if(element.gender=='Female')
        {
          femaleList.add(element);
        }
      else{
        otherList.add(element);
    }
    }
  );
  }
@override
  void initState() {

    super.initState();
    getMaleFemaleList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
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
            SliverPadding(padding: EdgeInsets.only(top: 10)),
            SliverToBoxAdapter(
              child: Container(
                height: Get.height * 0.1,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    homePageText("People List", top: 30, color: Colors.white),
                    GestureDetector(
                      onTap: () {
                        bottomMaleFemale(context);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 35),
                            child: Image.asset("assets/images/filter.png",
                                alignment: Alignment.centerLeft),
                          ),
                          homePageText("   Filter",
                              top: 30, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: // search bar
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
                        controller: _textEditingController,
                        onChanged:  _onSearchChanged('${_textEditingController?.text}'),
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Container(margin: EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
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
            ),
            SliverPadding(padding: EdgeInsets.only(top: 20)),
            SliverPadding(
                padding: EdgeInsets.only(left: 1, right: 8, top: 8, bottom: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.04,
                  ),
                  delegate: SliverChildBuilderDelegate(

                      childCount: showList.length,
                          (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                IndividualPeopleProfile(
                                ),
                            arguments: showList[index].id);
                          },
                          child: NearByPeopleProfile(
                            imageURL: showList[index].profilePicture,
                            name: showList[index].username,
                            id: showList[index].id,
                            likeStatus: showList[index].likeStatus,
                            onlineStatus: showList[index].onlineStatus,
                            privacyStatus: showList[index].privacyOnline,
                          ),
                          // personGrid(index: index),
                        );
                      }),
                )),
          ],
        ),
      ),
    );
  }

  Widget homePageText(String text, {Color color = Colors.black, int top = 20}) {
    return Container(
      margin: EdgeInsets.only(top: top.sp),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 14.sp, fontFamily: 'Poppins'),
      ),
    );
  }

  Widget personGrid({required int index}) {
    return SizedBox(
      height: Get.height * 0.25,
      width: Get.width * 0.25,
      /*padding: EdgeInsets.all(
        MediaQuery
            .of(context)
            .size
            .width * 0.015,
      ),*/
      child:
      Stack(
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
                    backgroundImage:
                    NetworkImage(widget.peopleList[index].profilePicture),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.03,
                    child: Icon(
                      Icons.message,
                      size: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.005,
                  ),
                  SizedBox(
                    width: Get.width * 0.15,
                    height: Get.height * 0.04,
                    child: Text(
                      widget.peopleList[index].username,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 10.sp,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: Get.height * 0.001,
            right: Get.width * 0.04,
            child: Container(
              width: Get.height * 0.032,
              height: Get.height * 0.032,
              padding: EdgeInsets.only(
                left: Get.height * 0.0045,
                top: Get.height * 0.00085,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100.sp),
              ),
              child: LikeButton(
                // onTap: onLikeButtonTapped,
                circleColor: const CircleColor(
                    start: Colors.white, end: Color(0xFFe3661d)),
                size: Get.height * 0.022,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: widget.peopleList[index].likeStatus == '1'
                        ? const Color(0xFFf9090a)
                        : Colors.white,
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
          Positioned(
            bottom: Get.height * 0.063,
            right: Get.height * 0.04,
            child: widget.peopleList[index].onlineStatus == 'on'
                ? Container(
              width: Get.height * 0.019,
              height: Get.height * 0.019,
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(100.sp),
              ),
              child: Icon(
                Icons.circle,
                color: Colors.green,
                size: Get.height * 0.016,
              ),
            )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future bottomMaleFemale(BuildContext context){
    return   showModalBottomSheet( context: context, builder: (context) {
      return GetBuilder<FilterChipController>(
        init: FilterChipController(),
        builder: (controller) {

        return Column( mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            iconText(Icons.people_outline, 'All People',    FilterChip(
                label: Text('All People'),
                selected: controller.list[0],
                selectedColor: Colors.red.shade900,
                backgroundColor: Colors.grey,
                labelStyle: TextStyle(color: Colors.white),
                onSelected: (value){
                  controller.setChip(selectedIndex: 0);
                 showList=widget.peopleList;
                 setState(() {

                 });
                } ),
            ),
            iconText(Icons.male, 'Male',  FilterChip(
              label: Text('Male'),
              selectedColor: Colors.red.shade900,
              backgroundColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.white),
              selected: controller.list[1],
              onSelected: (value){ controller.setChip(selectedIndex: 1);
              showList=maleList;
              setState(() {

              });
              }
              ),
              ),
            iconText(Icons.female, 'Female', FilterChip(
                label: Text('Female'),
                selected: controller.list[2],
                selectedColor: Colors.red.shade900,
                backgroundColor: Colors.grey,
                labelStyle: TextStyle(color: Colors.white),
                onSelected: (value) {
                  controller.setChip(selectedIndex: 2);
                  showList=femaleList;

                  setState(() {

                  });
                }),),


          ],
        );
      },);
    });
  }

  Widget iconText(IconData icon , String text , Widget widget ){
    return Container(margin: EdgeInsets.all(20),
      child: Row(children: [
      Icon(icon),
      SizedBox(width: Get.width*0.05,),
      widget
    ]),
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      log("jbflkasudghfaskfoookokokokokokokokokok  ${_textEditingController?.text}");
    });
  }
}

class MyFilterChip extends StatefulWidget {
  const MyFilterChip({super.key, required this.onChanged,required this.text, required this.status });

  final void Function(bool) onChanged;
  final String text;
  final bool status;
  @override
  State<MyFilterChip> createState() => MyFilterChipState();
}

class MyFilterChipState extends State<MyFilterChip> {
  bool _selected = false;
  void selectedStatus (){
    _selected = widget.status;
  }
  bool get selected => _selected;


  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.text),
      selected: _selected,
      onSelected: (value) {
        selectedStatus();
        setState(() => _selected = value);
        widget.onChanged(value);
      },
      selectedColor: Colors.red,
      backgroundColor: Colors.green,
      labelStyle: TextStyle(color: Colors.white),
    );
  }
}
class FilterChipController extends GetxController{
  List<bool> list = [true,false,false];

  void setChip({required int selectedIndex}){
    list= list.map((e) => false).toList();
    list[selectedIndex]=true;
    update();
  }


}