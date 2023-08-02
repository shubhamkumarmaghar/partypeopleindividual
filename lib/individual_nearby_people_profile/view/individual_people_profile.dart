import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../api_helper_service.dart';
import '../../widgets/block_unblock.dart';
import '../../widgets/individual_amenities.dart';
import '../controller/people_profile_controller.dart';
import '../model/people_profile_model.dart';

class IndividualPeopleProfile extends StatefulWidget {
  final String user_id;

  const IndividualPeopleProfile({Key? key, required this.user_id})
      : super(key: key);

  @override
  State<IndividualPeopleProfile> createState() =>
      _IndividualPeopleProfileState();
}

class _IndividualPeopleProfileState extends State<IndividualPeopleProfile> {
  PeopleProfileController peopleProfileController =
      Get.put(PeopleProfileController());
  List<Category> _categories = [];
  List<CategoryList> _categoryLists = [];
  List<OrganizationAmenities>? amenties=[];
  List selectedAmenities = [];

  Future<void> _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://app.partypeople.in/v1/party/individual_organization_amenities'),
        headers: {'x-access-token': '${GetStorage().read('token')}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          if (data['status'] == 1) {
            _categories = (data['data'] as List)
                .map((category) => Category.fromJson(category))
                .toList();

            _categories.forEach((category) {
              _categoryLists.add(CategoryList(
                  title: category.name, amenities: category.amenities));
            });
            getSelectedID();
          } else {
            print('Error with the data status: ${data['status']}');
          }
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  void getSelectedID() {
    print(peopleProfileController.amentiesdata);
    for (var i = 0; i < peopleProfileController.amentiesdata.length; i++) {
      var amenityName = peopleProfileController.amentiesdata[i].name;
      print(amenityName);
      setState(() {
        _categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.name == amenityName) {
              if (selectedAmenities
                  .contains(amenity.id)) {
              } else {
                selectedAmenities.add(amenity.id);
              }
              amenity.selected = true;
            }
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    peopleProfileController.PeopleViewed(widget.user_id);
    _fetchData();
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
          log("${amenties?[0].name}");
          return SingleChildScrollView(
              child: Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    //Cover Photo
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          //topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Color(0xff390202),
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
                    ),
                    // Profile Photo
                    Positioned(
                      bottom: 10,
                      child: Container(
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
                        child: CircleAvatar(
                            radius: 55,

                            backgroundImage: data?.profilePic != null
                                ? NetworkImage('${data?.profilePic}')
                                : NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fman.png?alt=media&token=53575bc0-dd6c-404e-b8f3-52eaf8fe0fe4')),
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
                              BlockUnblock.showBlockedAlertDialog(
                                  context, '${data?.userId}', 'Block');
                            },
                            child: iconButtonNeumorphic(icon: Icons.block,color: Colors.red),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.to(peopleList());
                            },
                            child: iconButtonNeumorphic(
                                icon: CupertinoIcons.chat_bubble_2_fill,color: Colors.orange),
                          ),
                          data?.likeStatus ==1 ?iconButtonNeumorphic(
                              icon: Icons.favorite,color: Colors.red):
                          GestureDetector(
                            onTap: () async {
                            data?.likeStatus =  await APIService.likePeople(widget.user_id, true) ;
                            setState(() {

                            });
                            },
                            child: iconButtonNeumorphic(
                                icon: Icons.favorite_border_rounded,color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                              CustomTextview(data?.name ?? "NA", Icons.person),
                        ),
                        Expanded(
                          child:
                              CustomTextview(data?.name ?? "NA", Icons.person),
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
                                  color: Colors.grey),
                              SizedBox(
                                width: Get.width * 0.03,
                              ),
                              Container(
                                width: Get.width * 0.75,
                                child: Text(
                                  data?.bio ?? "NA",
                                  maxLines: 5,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextview(
                              data?.dob ?? "NA", Icons.calendar_month),
                        ),
                        Expanded(
                          child: CustomTextview(
                              data?.gender ?? "NA", Icons.people),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextview(data?.qualification ?? "NA",
                              Icons.description_outlined),
                        ),
                        Expanded(
                          child: CustomTextview(
                              data?.occupation ?? "NA", Icons.work),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextview(
                              data?.country ?? "NA", Icons.location_on),
                          //QualificationWidget(),
                        ),
                        Expanded(
                          child: CustomTextview(
                              data?.state ?? "NA", Icons.location_on),

                          //OccupationWidget(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextview(
                              data?.city ?? "NA", Icons.location_city),
                          //QualificationWidget(),
                        ),
                        Expanded(
                          child: CustomTextview(
                              data?.pincode ?? "NA", Icons.pin_drop),

                          //OccupationWidget(),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),
                    Text("Hobbies",style: TextStyle(color: Colors.black54,fontSize: 20),),
                    _categoryLists.isEmpty
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
                      physics:
                      const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          physics:
                          const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _categoryLists.length,
                          itemBuilder: (context, index) {
                            final categoryList =
                            _categoryLists[index];

                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryList.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.bold,
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
                                          child:
                                          Chip(
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
                                                color:
                                                Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            backgroundColor:
                                                 Colors.red,
                                          ),
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
          ));
        },
      ),
    );
  }

  Widget iconButtonNeumorphic({required IconData icon ,required Color color}) {
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

  Widget CustomTextview(String text, IconData icon) {
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
              width: Get.width*.28,
              height: Get.height*0.02,
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
}
