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
import 'package:sizer/sizer.dart';

import '../../api_helper_service.dart';
import '../../individual_profile_screen/individual_people_list.dart';
import '../../widgets/block_unblock.dart';
import '../controller/people_profile_controller.dart';
import '../model/people_profile_model.dart';

class IndividualPeopleProfile extends StatefulWidget {

  final String user_id ;
  const IndividualPeopleProfile({Key? key,required this.user_id}) : super(key: key);

  @override
  State<IndividualPeopleProfile> createState() => _IndividualPeopleProfileState();
}

class _IndividualPeopleProfileState extends State<IndividualPeopleProfile> {

  PeopleProfileController peopleProfileController = Get.put(PeopleProfileController());
  @override
  void initState() {
    super.initState();
    peopleProfileController.PeopleViewed(widget.user_id);
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
      body:GetBuilder<PeopleProfileController>(
        init:PeopleProfileController(),
        builder: (controller) {
          var data = controller.peopleProfileData.data;
          final List<OrganizationAmenities>? amenties = data?.organizationAmenities;
          log("${amenties?[0].name}");
          return  SingleChildScrollView(
            child: Container(
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
              child:Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      //Cover Photo
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0xff390202),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: controller.peopleProfileData.data?.coverPhoto==null?
                            NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f')
                                :
                            NetworkImage(
                                '${controller.peopleProfileData.data?.coverPhoto}')
                            ,
                          ),
                        ),
                      ),
                      // Profile Photo
                      Positioned(
                        bottom: 0,
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
                              /*   backgroundImage: data.profilePic == null
                                ? const AssetImage(
                                'assets/images/man.png')
                                : FileImage(_profileImage!)
                            as ImageProvider<Object>,

                          */

                              backgroundImage: data?.profilePic != null?
                              NetworkImage('${data?.profilePic}'):NetworkImage('https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fman.png?alt=media&token=53575bc0-dd6c-404e-b8f3-52eaf8fe0fe4')

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
                      Container(margin: EdgeInsets.only(left: 30,right: 30,top: 15,),
                        child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          GestureDetector(
                            onTap: () {
                              //  peopleProfileController.apiService.DoBlockUnblockPeople('${data?.userId}', 'Block');
                              BlockUnblock.showBlockedAlertDialog(context, '${data?.userId}', 'Block');
                            },
                            child: iconButtonNeumorphic(icon: Icons.block),
                          ),

                          GestureDetector(
                            onTap: () {
                              Get.to(peopleList());
                            },
                            child:iconButtonNeumorphic(icon: Icons.favorite_border_rounded),
                          ),
                        ],
                        ) ,
                      ),


                      profilepersonaldata(data?.name??"NA",data?.dob??'NA',data?.gender??'NA',data?.bio??'NA'),

                      addressprofiledata(data?.country??"NA",data?.state??'NA',data?.city??'NA'),
                      Container(width: Get.width,
                        height: Get.height*0.2,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.only(left: 20.0,right: 20.0,top: 15),
                          child:
                          ListView.builder(itemCount: amenties?.length??0,
                            itemBuilder: (context ,index){
                              return
                                Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,),
                                  // margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      customPeopleProfileText(color:Colors.black54 ,text:amenties?[index].name??"" ,size:14 ),
                                      //const SizedBox(height: 10.0),
                                    ],
                                  ),


                                );

                            },
                          ),
                        ), ),

                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),



                ],
              ) ,
            )

          );
        },
      ),

    );

  }


  Widget profilepersonaldata(String name , String dob , String gender , String decription)
  {
    log('$name  $dob   $gender   $decription');
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(left: 10,right: 10,top: 10),

      child:Card(
        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child:
        Padding(
          padding:
          const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details :',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'Name :' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$name' ,size:12 ),
]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              customPeopleProfileText(color:Colors.black54 ,text:'D.O.B :' ,size:12 ),
              customPeopleProfileText(color:Colors.black54 ,text:'$dob' ,size:12 ),
          ],),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'Gender : ' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$gender' ,size:12 ),
              ],),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'Description :' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$decription' ,size:12 ),
              ],),

            ],
          ),
        ),
      ) ,
    );

  }

  Widget iconButtonNeumorphic({required IconData icon }){
    return Neumorphic(padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
    border: NeumorphicBorder(
    color: Color(0x33000000),
    width: 0.8,)
   ,
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
           depth: 0.2,
            intensity: 5,
            surfaceIntensity: 0.5,

            lightSource: LightSource.bottomRight,
            color: Colors.white,
        ),
        child: NeumorphicIcon(icon,size: 40,style: NeumorphicStyle(color: Colors.red),)
    );
  }


  Widget addressprofiledata(String country , String city , String state)
  {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
      child:Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child:
        Padding(
          padding:
          const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              customPeopleProfileText(color:Colors.black ,text:'Address' ,size:14 ),
              const SizedBox(height: 10.0),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'Country :' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$country' ,size:12 ),
              ],),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'State :' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$state' ,size:12 ),
              ],),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                customPeopleProfileText(color:Colors.black54 ,text:'City :' ,size:12 ),
                customPeopleProfileText(color:Colors.black54 ,text:'$city' ,size:12 ),
              ],),

            ],
          ),
        ),
      ) ,
    );

  }

  Widget amentiesprofiledata(String country , String city , String state)
  {
    return Container(
      width: Get.width,
      margin: EdgeInsets.all(10),
      child:Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child:
        Padding(
          padding:
          const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Country: $country',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'State : $state',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "City: $city",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black,
                ),
              ),

            ],
          ),
        ),
      ) ,
    );

  }

  Widget customPeopleProfileText({required String text , required Color color , required double size })
{
  return Text(
  text,
  style:  TextStyle(
fontSize: size.sp,
fontWeight: FontWeight.bold,
color: color,
),
);
}



}
