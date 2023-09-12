import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../api_helper_service.dart';
import '../../chatScreen/views/chat_screen_view.dart';
import '../../individual_profile_screen/profilephotoview.dart';
import '../../individual_subscription/view/subscription_view.dart';
import '../../widgets/block_unblock.dart';
import '../../widgets/calculate_age.dart';
import '../../widgets/custom_textview_profile.dart';
import '../controller/people_profile_controller.dart';
import '../model/people_profile_model.dart';

class IndividualPeopleProfile extends StatefulWidget {
  const IndividualPeopleProfile({Key? key}) : super(key: key);

  @override
  State<IndividualPeopleProfile> createState() =>
      _IndividualPeopleProfileState();
}

class _IndividualPeopleProfileState extends State<IndividualPeopleProfile> {
  // PeopleProfileController peopleProfileController = Get.put(PeopleProfileController());

  @override
  void initState() {
    super.initState();

    // peopleProfileController.PeopleViewed(widget.user_id);
    //_fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<PeopleProfileController>(
        init: PeopleProfileController(),
        builder: (controller) {
          var data = controller.peopleProfileData.data;
          final List<OrganizationAmenities>? amenties =
              data?.organizationAmenities;
          return data != null
              ? SingleChildScrollView(
                  child: Container(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          //Cover Photo
                          /* Container(
                      height: Get.height*0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          //topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        //color: Color(0xff390202),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: controller
                                      .peopleProfileData.data?.coverPhoto ==
                                  null
                              ? NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f')
                              : NetworkImage(
                                  '${controller.peopleProfileData.data?.coverPhoto}'),
                        ),
                      ),
                    ),*/
                          Container(
                            height: Get.height * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade400,
                                period: const Duration(milliseconds: 1500),
                                child: Container(
                                  height: Get.height * 0.35,
                                  color: Color(0xff7AB02A),
                                ),
                              ),
                              imageUrl: controller
                                          .peopleProfileData.data?.coverPhoto ==
                                      null
                                  ? 'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f'
                                  : '${controller.peopleProfileData.data?.coverPhoto}',
                              width: Get.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Profile Photo
                          Positioned(
                            bottom: 10,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProfilePhotoView(
                                      profileUrl: data.profilePic ?? "",
                                    ));
                              },
                              child: Container(
                                height: Get.height * 0.11,
                                width:  Get.height * 0.11,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black38,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child:ClipRRect(

                                 borderRadius: BorderRadius.all(Radius.circular(50)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: Colors.grey.shade400,
                                      period: const Duration(milliseconds: 1500),
                                      child: Container(
                                        height: Get.height * 0.35,
                                        color: Color(0xff7AB02A),
                                      ),
                                    ),
                                    imageUrl: data.profilePic == null
                                        ? 'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f'
                                        : data.profilePic ??'',
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                  ),
                                )



                              //   CircleAvatar(
                              //       radius: 55,
                              //       backgroundColor: Colors.transparent,
                              //       backgroundImage: data.profilePic != null
                              //           ? NetworkImage('${data.profilePic}')
                              //           : NetworkImage(
                              //               'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fman.png?alt=media&token=53575bc0-dd6c-404e-b8f3-52eaf8fe0fe4'),
                              // ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      ///Other Individual Widget
                      const SizedBox(
                        height: 10,
                      ),

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //  peopleProfileController.apiService.DoBlockUnblockPeople('${data?.userId}', 'Block');
                                    Alertdialogs.showBlockedAlertDialog(
                                        context, '${data.userId}', 'Block');
                                  },
                                  child: iconButtonNeumorphic(
                                      icon: Icons.block, color: Colors.red.shade900),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ChatScreenView(),
                                        arguments: controller.userId);
                                    //?.then((value) => APIService.lastMessage(controller.userId, GetStorage().read('last_message')));
                                    // Get.to(peopleList());
                                  },
                                  child: iconButtonNeumorphic(
                                      icon: CupertinoIcons.chat_bubble_2_fill,
                                      color: Colors.orange),
                                ),
                                data.likeStatus == 1
                                    ? iconButtonNeumorphic(
                                        icon: Icons.favorite, color: Colors.red.shade900)
                                    : GestureDetector(
                                        onTap: () async {
                                          data.likeStatus =
                                              await APIService.likePeople(
                                                  controller.userId, true);
                                          setState(() {});
                                        },
                                        child: iconButtonNeumorphic(
                                            icon: Icons.favorite_border_rounded,
                                            color: Colors.red.shade900),
                                      ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextView(text:
                                    data.name?.split(' ')[0].capitalizeFirst ??
                                        "NA",
                                  icon:   Icons.person),
                              ),
                              Expanded(
                                child: CustomProfileTextView(
                                    icon:
                                    Icons.person, text: data.name
              ?.split(" ")
              .last
              .capitalizeFirst ??
          "NA",),
                              ),
                            ],
                          ),
                          Container(
                            height: Get.height * 0.15,
                            child: Neumorphic(
                                margin: const EdgeInsets.all(12.0),
                                padding: EdgeInsets.all(12.0),
                                style: NeumorphicStyle(
                                  intensity: 0.8,
                                  surfaceIntensity: 0.25,
                                  depth: 8,
                                  shape: NeumorphicShape.flat,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.grey
                                      .shade100, // Very light grey for a softer look
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.description_outlined,
                                        color: Colors.red.shade900),
                                    SizedBox(
                                      width: Get.width * 0.03,
                                    ),
                                    Container(
                                      width: Get.width * 0.75,
                                      child: Text(
                                        data.bio.toString().capitalizeFirst ??
                                            "",
                                        maxLines: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextView(
                                    text: CalculateAge.calAge(data.dob ?? ""),
                                   icon:  Icons.calendar_month),
                              ),
                              Expanded(
                                child: CustomProfileTextView(
                                 text:    data.gender ?? "NA",icon:  Icons.people),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextView(
                                text:     data.qualification ?? "NA",
                                  icon:   Icons.description_outlined),
                              ),
                              Expanded(
                                child: CustomProfileTextView(
                                 text:    data.occupation ?? "NA",
                                    icon: Icons.work),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextView(
                                  text:   data.country ?? "NA",
                                    icon: Icons.location_on),
                                //QualificationWidget(),
                              ),
                              Expanded(
                                child: CustomProfileTextView(
                                text:     data.state ?? "NA",
                                    icon: Icons.location_on),

                                //OccupationWidget(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProfileTextView(
                                   text:  data.city ?? "NA",
                                    icon: Icons.location_city),
                                //QualificationWidget(),
                              ),
                              Expanded(
                                child: CustomProfileTextView(
                                 text: data.pincode ?? "NA",
                                    icon:Icons.pin_drop),

                                //OccupationWidget(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Interests",
                            style:
                                TextStyle(color: Colors.black, fontSize: 22,),
                          ),
                          controller.categoryLists.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: const Center(
                                      child: CupertinoActivityIndicator(
                                        radius: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ListView.builder(
                                      padding: const EdgeInsets.all(10.0),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.categoryLists.length,
                                      itemBuilder: (context, index) {
                                        final categoryList =
                                            controller.categoryLists[index];
                                        return Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          margin: const EdgeInsets.all(10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  categoryList.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Wrap(
                                                  spacing: 6.0,
                                                  runSpacing: 6.0,
                                                  children: categoryList
                                                      .amenities
                                                      .map((amenity) {
                                                    return GestureDetector(
                                                      /*  onTap: () =>
                                          _selectAmenity(
                                              amenity),
                                      */
                                                      child: amenity.selected
                                                          ? Chip(
                                                              /*avatar: CircleAvatar(
                                          backgroundColor:
                                          amenity.selected
                                              ? Colors.red[
                                          700]
                                              : Colors.grey[
                                          700],
                                        ), */
                                                              label: Text(
                                                                amenity.name,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red.shade900,
                                                            )
                                                          : Visibility(visible: false,child: Container()),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                ),

                          /*  Container(
                      width: Get.width,
                      height: Get.height * 0.2,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15),
                        child: ListView.builder(
                          itemCount: amenties?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              // margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customAmetiesText(
                                      color: Colors.white,
                                      text: amenties?[index].name ?? "",
                                      size: 14),
                                  //const SizedBox(height: 10.0),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    */
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget iconButtonNeumorphic({required IconData icon, required Color color}) {
    return Neumorphic(
        padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.circle(),
          depth: 0.2,
          intensity: 5,
          surfaceIntensity: 0.5,
          lightSource: LightSource.bottomLeft,
          color: Colors.white,
        ),
        child: NeumorphicIcon(
          icon,
          size: 25,
          style: NeumorphicStyle(color: color),
        ));
  }

  Widget customAmetiesText(
      {required String text, required Color color, required double size}) {
    return Chip(
      /*avatar: CircleAvatar(
                                          backgroundColor:
                                          amenity.selected
                                              ? Colors.red[
                                          700]
                                              : Colors.grey[
                                          700],
                                        ), */
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: Colors.red,
    );
    /*Text(
      text,
      style: TextStyle(
        fontSize: size.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    ); */
  }

 /* Widget CustomProfileTextView(String text, IconData icon) {
    return Neumorphic(
        margin: const EdgeInsets.all(12.0),
        padding: EdgeInsets.all(12.0),
        style: NeumorphicStyle(
          intensity: 0.8,
          surfaceIntensity: 0.25,
          depth: 8,
          shape: NeumorphicShape.flat,
          lightSource: LightSource.topLeft,
          color: Colors.grey.shade100, // Very light grey for a softer look
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            SizedBox(
              width: Get.width * 0.03,
            ),
            Container(
              width: Get.width * .28,
              height: Get.height * 0.02,
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: NeumorphicText(text,
                    style: NeumorphicStyle(
                      color: Colors.black54,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 14,
                    )),
              ),
            ),
          ],
        ));
  }
*/
  String calAge(String birthdate) {
    try {
      int age;
      if (birthdate == '') {
        return "NA";
      } else {
        DateTime birthDate = DateTime.parse(birthdate);
        DateTime currentDate = DateTime.now();
        age = currentDate.year - birthDate.year;
        int month1 = currentDate.month;
        int month2 = birthDate.month;
        if (month2 > month1) {
          age--;
        } else if (month1 == month2) {
          int day1 = currentDate.day;
          int day2 = birthDate.day;
          if (day2 > day1) {
            age--;
          }
        }
      }
      log("$age");
      return age.toString() + ' Years';
    } catch (e) {
      log('${e}');
      return "NA";
    }
  }
}
