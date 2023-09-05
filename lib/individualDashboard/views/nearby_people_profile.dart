import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:partypeopleindividual/individual_subscription/view/subscription_view.dart';
import 'package:sizer/sizer.dart';

import '../../chatScreen/views/chat_screen_view.dart';
import '../controllers/individual_dashboard_controller.dart';

class NearByPeopleProfile extends StatefulWidget {
  final String imageURL;
  final String name;
  final String id;
  String likeStatus;
  final String onlineStatus;
  final String privacyStatus;

  NearByPeopleProfile({
    super.key,
    required this.name,
    required this.imageURL,
    required this.id,
    required this.likeStatus,
    required this.onlineStatus,
    required this.privacyStatus
  });

  @override
  State<NearByPeopleProfile> createState() => _NearByPeopleProfileState();

}

class _NearByPeopleProfileState extends State<NearByPeopleProfile> {
  IndividualDashboardController controller = Get.find<IndividualDashboardController>();
 String approvalStatus =GetStorage().read('approval_status')??'0';
  String newUser = GetStorage().read('newUser')??'0';
  String plan = GetStorage().read('plan_plan_expiry')??'Yes';

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    ///
    print("$isLiked");
    if(approvalStatus =='1') {
          if (widget.likeStatus == '1') {
            return isLiked;
          }
          else {
            isLiked = widget.likeStatus == '1' ? false : true;
            final response = await http.post(
              Uri.parse(
                  'https://app.partypeople.in/v1/account/individual_user_like'),
              headers: <String, String>{
                'x-access-token': '${GetStorage().read('token')}',
              },
              body: <String, String>{
                'user_like_status': isLiked == true ? "yes" : "No",
                'user_like_id': widget.id
              },
            );

            if (response.statusCode == 200) {
              // If the server returns a 200 OK response,
              // then parse the JSON.
              Map<String, dynamic> jsonResponse = jsonDecode(response.body);
              print(jsonResponse);
              if (jsonResponse['status'] == 1 &&
                  jsonResponse['message'] == ('User liked successfully')) {
                print('User like save successfully');
                isLiked = false;
                widget.likeStatus = '1';
                setState(() {}
                );
                 controller.animateHeart();
                controller.update();

              } else if (jsonResponse['status'] == 1 &&
                  jsonResponse['message'] == ('User unliked successfully')) {
                print('User unlike successfully');
                isLiked = true;
                widget.likeStatus = '1';
              } else {
                print('Failed to like/ unlike ');
                isLiked = true;
                widget.likeStatus = '0';
              }
            } else {
              // If the server did not return a 200 OK response,
              // then throw an exception.
              throw Exception('Failed to like/unlike');
            }
          }
        }
    else {
      Get.snackbar('Sorry!',
          'Your account is not approved , please wait until it got approved');
    }

    return isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.23,
      width: Get.width * 0.23,
      /*padding: EdgeInsets.all(
        MediaQuery
            .of(context)
            .size
            .width * 0.015,
      ),*/
      child: FittedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget != null
                ? Column(
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
                          borderRadius:
                              BorderRadius.circular(100.sp), //<-- SEE HERE
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(Get.width * 0.001),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(widget.imageURL),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(()=>ChatScreenView);
                            },
                            child: SizedBox(
                            width: Get.width * 0.03,
                            child:  Icon(CupertinoIcons.chat_bubble_2_fill,
                                  size: MediaQuery.of(context).size.height * 0.02,
                                  color: const Color(0xFFe3661d)),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.005,
                          ),
                          SizedBox(
                            width: Get.width * 0.15,
                            height: Get.height * 0.04,
                            child: Text(
                              widget.name,
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
                  )
                : Column(
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

                            borderRadius:
                                BorderRadius.circular(100.sp), //<-- SEE HERE
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Get.width * 0.001),
                            child: CircleAvatar(
                                // backgroundImage: NetworkImage(widget.imageURL),
                                ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ]),
            Positioned(
              top: Get.height * 0.001,
              right: Get.width * 0.001,
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
                child:
                    /*   IconButton(
                  onPressed: (){
                  },
                  icon: Icon(Icons.favorite ,color: likeStatus=='1' ? const Color(0xFFf9090a) : Colors.white,
                  size: Get.height * 0.022,),

                ) */

                    LikeButton(
                  onTap: onLikeButtonTapped,
                  circleColor: const CircleColor(
                      start: Colors.white, end: Color(0xFFe3661d)),
                  size: Get.height * 0.022,
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: widget.likeStatus == '1'
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
              bottom: Get.height * 0.05,
              right: Get.height * 0.015,
              child: widget.onlineStatus == 'on'&& widget.privacyStatus == 'Yes'
                  ? Container(
                      width: Get.height * 0.019,
                      height: Get.height * 0.019,
                      // color: Colors.white,
                      decoration: BoxDecoration(
                        color: const Color(0xFFe3661d),
                        borderRadius: BorderRadius.circular(100.sp),
                      ),

                      /*  padding: EdgeInsets.only(
                    left: Get.height * 0.029,
                    top: Get.height * 0.00045,
                  ), */

                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: Get.height * 0.018,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
