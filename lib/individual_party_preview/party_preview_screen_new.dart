import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:partypeopleindividual/individual_party_preview/single_party_previewController/single_party_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:sizer/sizer.dart';
import 'package:confetti/confetti.dart';
import 'package:shimmer/shimmer.dart';
import '../api_helper_service.dart';
import '../centralize_api.dart';
import '../firebase_custom_event.dart';
import '../individualDashboard/controllers/individual_dashboard_controller.dart';
import '../individualDashboard/models/party_model.dart';
import '../join_party_details/view/join_party_details.dart';
import '../party_organization_details_view/view/organization_detalis_view.dart';


class PartyPreviewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
 // final Party party;
  String id;

   PartyPreviewScreen({super.key,required this.id
  // required this.party
  });

  @override
  State<PartyPreviewScreen> createState() => _PartyPreviewScreenState();
}

class _PartyPreviewScreenState extends State<PartyPreviewScreen> {
  IndividualDashboardController dashboardController = Get.find();
  int noOfPeople = 2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String join = 'Book Now';
  Party? getSingleParty;
  late ConfettiController _controllerBottomCenter;


  @override
  void initState() {
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    //controller.getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      GetBuilder<PartyPreviewScreenController>(
        init:PartyPreviewScreenController(widget.id) ,
       builder: (controller) {
          var getSingleParty = controller.party;
          return
        controller.isLoading.value == false ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.red.shade900,
                            ),
                            backgroundColor: Colors.grey.shade200,
                          )),
                    ),
                    GestureDetector(
                      onTap: () async{
                        String mydata = '${controller.party?.id}';
                        String bs64 = base64.encode(mydata.codeUnits);
                       // print('bs64  $mydata $bs64 ${controller.party?.sharePartyUrl}}');
                        FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
                        final dynamicLinkParams = await DynamicLinkParameters(
                          link: Uri.parse("https://partypeopleindividual.page.link"),
                          uriPrefix: "https://partypeopleindividual.page.link",

                          androidParameters: const AndroidParameters(
                              packageName: "com.partypeopleindividual",
                          minimumVersion: 0),
                          iosParameters: const IOSParameters(bundleId: "com.partypeople.individual",
                          minimumVersion: '0'),
                        );
                        final dynamicLink = await dynamicLinks.buildLink(dynamicLinkParams);
                      dev.log('dynamic link :: $dynamicLink   -- ${controller.party?.sharePartyUrl}');
                     /*  final dynamicLinkk =
                            await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams,
                          shortLinkType: ShortDynamicLinkType.unguessable,);
                       print('short :::$dynamicLinkk  ');*/
                        String sharedLink = '${dynamicLink.toString()}/$bs64/party';
                        Share.share(sharedLink);
                        //Get.back();
                      },
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.share,
                              color: Colors.red.shade900,
                            ),
                            backgroundColor: Colors.grey.shade200,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    if (controller.party?.imageStatus == '1')
                      Card(
                        elevation: 5,
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(bottom: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: CarouselSlider(
                          items: controller.partyImages
                              .map((element) => customImageSlider(
                                  partyPhotos: element,
                                  imageStatus: '${controller.party?.imageStatus}'))
                              .toList(),
                          options: CarouselOptions(
                            height: Get.height * 0.295,
                            // enlargeCenterPage: true,
                            autoPlay: true,
                            //aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            viewportFraction: 1
                          ),
                        ),
                      )
                    else
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.only(bottom: 25),
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: CarouselSlider(
                          items: controller.partyImages
                              .map((element) => customImageSlider(
                                  partyPhotos: element,
                                  imageStatus: '${controller.party?.imageStatus}'))
                              .toList(),
                          options: CarouselOptions(
                              height: Get.height * 0.295,
                              // enlargeCenterPage: true,
                              autoPlay: true,
                              //aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 1),
                        ),
                      ),
                    Positioned(
                        top: Get.height * 0.27,
                        right: Get.width * 0.06,
                        child:bookNowButton(),
                      /*  GestureDetector(
                          onTap: () async {
                            var data =
                                await APIService.ongoingParty(controller.party?.id);
                            if (data == true) {
                              setState(() {});
                              join = 'Booked';
                              _controllerBottomCenter.play();
                            }
                            print('ongoing status ${controller.party?.ongoingStatus}');
                            controller.party?.ongoingStatus != 1 ?
                            joinPartyFormDialouge(context: context):
                            Fluttertoast.showToast( msg: 'You are already booked this offer',);
                          },
                          child: Container(
                            width: Get.width * 0.2,
                            height: Get.height * 0.04,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.orange,
                            ),
                            child: FittedBox(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.add_circled,
                                        color: Colors.white),
                                    SizedBox(
                                      width: Get.width * 0.003,
                                    ),
                                    controller.party?.ongoingStatus == 0
                                        ? Text(
                                            join,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 16),
                                          )
                                        : Text(
                                            "Booked",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 16),
                                          )
                                  ]),
                            ),
                          ),
                        )*/
                    ),
                  ],
                ),

                /* Stack(children: [
                      if (controller.party?.imageStatus == '1')
                        Card(elevation: 5,
                        margin: EdgeInsets.only(bottom: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15.0),),
                        child:  Container(
                        //backgroundColor: Colors.grey.shade100,
                        height: Get.height*0.295,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image:DecorationImage( image: NetworkImage(controller.party?.coverPhoto),fit: BoxFit.cover ),
                        ),
                        width: Get.width,
                        /* child: Image.network(
                          controller.party?.coverPhoto,
                          width: Get.width,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          },
                        ), */
                        ),
                    ) else Card(elevation: 5,
                          margin: EdgeInsets.only(bottom: 25),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15.0),),
                      child: Container(
                        padding: EdgeInsets.zero,
                        height: Get.height*0.295,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image:DecorationImage( image: NetworkImage(controller.party?.coverPhoto),fit: BoxFit.cover ),
                        ),
                        width: Get.width,
                        /* child: Image.network(
                        controller.party?.coverPhoto,
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                    ),
                          */
                      ),
                        ),

                      Positioned(
                          top: Get.height*0.27,
                          right: Get.width*0.06,
                          child: GestureDetector(onTap: () async {

                            var data = await APIService.ongoingParty(controller.party?.id);
                            if(data ==true)
                              {
                                setState(() {

                                });
                                join='Joined';
                                _controllerBottomCenter.play();
                              }
                            //ongoingParty(controller.party?.id);

                          },
                            child: Container(
                              width: Get.width*0.2,
                              height: Get.height*0.04,
                              padding: EdgeInsets.all(5),
                              decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(12),
                                color: Colors.orange,),
                              child:  FittedBox(
                                child: Row(mainAxisAlignment: MainAxisAlignment.center
                                    ,children: [
                                      Icon(CupertinoIcons.add_circled,color: Colors.white),
                                      SizedBox(width: Get.width*0.003,),
                                      controller.party?.ongoingStatus == 0 ?
                                      Text(join,style: TextStyle(color: Colors.white,
                                          fontSize: 16),) : Text("Joined",style: TextStyle(color: Colors.white,
                                          fontSize: 16),)
                                    ]
                                ),
                              ),
                            ),
                          )),


                    ],),*/
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  CustomTextIcon(
                      icon: CupertinoIcons.heart,
                      IconText: "${controller.party?.like} Likes"),
                  CustomTextIcon(
                      icon: CupertinoIcons.eye,
                      IconText: "${controller.party?.view} Views"),
                  CustomTextIcon(
                      icon: CupertinoIcons.person_3,
                      IconText: "${controller.party?.ongoing} Going"),
                ]),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  '${controller.party?.title.capitalizeFirst}',
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'malgun',
                      fontSize: 28,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${controller.party?.description.capitalizeFirst}',
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'malgun',
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                        () => OrganizationDetaisView(
                              organizationData: '${controller.party?.userId}',
                              mobileno: '${controller.party?.phoneNumber}',
                            ),
                        arguments: controller.party?.userId);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Organized By : ',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'malgun',
                            fontSize: 14.sp,
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.orange,
                        ),
                        child: FittedBox(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.003,
                                ),
                                Text(
                                  ' ${controller.party?.organization.capitalizeFirst!} ',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 16),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                /* controller.party?.papularStatus == '1'
                        ? CustomListTile(
                      icon: Icons.calendar_month_outlined,
                      title: "Popular Party Dates",
                      subtitle:
                      "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(controller.party?.prStartDate))} to ${controller.party?.endDate != null ? DateFormat('EEEE, d MMMM y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(controller.party?.endDate) * 1000)) : ''}",
                      sub: true,
                    )
                        : Container(),
                    */
                /* controller.party?.papularStatus == '1'
                        ? CustomListTile(
                      icon: Icons.calendar_month_outlined,
                      title: "Popular Party Dates",
                      subtitle:
                      "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(controller.party?.prStartDate))}",
                      sub: true,)
                        :
                    */
                CustomListTile(
                  icon: Icons.calendar_month,
                  title:
                      "${controller.party?.prStartDate != null ? DateFormat('d MMMM, y').format(DateTime.fromMillisecondsSinceEpoch(int.parse('${controller.party?.startDate}') * 1000)) : ''} ",
                  subtitle:
                      "${controller.party?.startTime}  to  ${controller.party?.endTime}",
                  sub: true,
                ),
                CustomListTile(
                  icon: Icons.location_on,
                  title: "${controller.party?.latitude} ",
                  subtitle: "${controller.party?.longitude} , ${controller.party?.pincode}",
                  sub: true,
                ),
                /*   CustomListTile(
                    icon: Icons.favorite,
                    title: "${controller.party?.like} Likes",
                    subtitle: "${controller.party?.like} Likes",
                    sub: false,
                  ),

                  CustomListTile(
                    icon: Icons.remove_red_eye_sharp,
                    title: "${controller.party?.view} Views",
                    subtitle: "${controller.party?.view} Views",
                    sub: false,
                  ),
                  CustomListTile(
                    icon: Icons.group_add,
                    title: "${controller.party?.ongoing} Goings",
                    subtitle: "${controller.party?.ongoing} Goings",
                    sub: false,
                  ),

                  */
                CustomListTile(
                  icon: Icons.supervised_user_circle_outlined,
                  title:
                      '${controller.party?.gender.replaceAll('[', '').replaceAll(']', '')}',
                  subtitle: '${controller.party?.gender
                      .replaceAll('[', '')
                      .replaceAll(']', '')
                      .capitalizeFirst!}',
                  sub: false,
                ),
                GestureDetector(
                  onTap: () {
                    UrlLauncher.launch("tel://${controller.party?.phoneNumber}");
                  },
                  child: CustomListTile(
                    icon: Icons.phone,
                    title: "Call Us",
                    subtitle: '${controller.party?.phoneNumber}',
                    sub: true,
                  ),
                ),
                CustomListTile(
                  icon: Icons.group,
                  title: "${controller.party?.startAge} to ${controller.party?.endAge}  age",
                  subtitle: "${controller.party?.startAge} - ${controller.party?.endAge} ",
                  sub: false,
                ),
                CustomListTile(
                  icon: Icons.warning,
                  title: "Maximum Guests",
                  subtitle: '${controller.party?.personLimit}',
                  sub: true,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.party?.discountType =='0' || controller.party?.discountAmount == '0'?CustomListTile(
                      icon: Icons.local_offer,
                      title: "Offers",
                      subtitle: '${controller.party?.offers}',
                      sub: true,
                    ):

                    CustomListTile(
                      icon: Icons.local_offer,
                      title: "Discount ",
                      subtitle:controller.party?.discountType == '1' ? 'Get ${controller.party?.discountAmount}% off ${controller.party?.billMaxAmount !='0' ? 'upto ₹${controller.party?.billMaxAmount}':""} .' : 'Get flat ₹${controller.party?.discountAmount} off ${controller.party?.billMaxAmount !='0' ? 'on minimum ₹${controller.party?.billMaxAmount}':""} .',
                      sub: true,
                    ),
                   bookNowButton()
                  ],
                ),
               controller.party?.discountDescription != ""?
              Text('                  ${controller.party?.discountDescription.toString().capitalizeFirst}',
    style: const TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 14,
                  color: Colors.black87,
                ) ):Container(),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    // color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      /*  BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),*/
                    ],
                  ),
                  //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Icon(
                          Icons.currency_rupee,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entry Fees',
                            style: TextStyle(
                                fontFamily: 'malgun',
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 4, bottom: 5),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Ladies',
                                      style: TextStyle(
                                          fontFamily: 'malgun',
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Couples',
                                      style: TextStyle(
                                          fontFamily: 'malgun',
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Stag',
                                      style: TextStyle(
                                          fontFamily: 'malgun',
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Others',
                                      style: TextStyle(
                                          fontFamily: 'malgun',
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    controller.party?.ladies == '0'
                                        ? const Text(
                                            "  - NA",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "  - ₹ ${controller.party?.ladies}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                    controller.party?.couples == '0'
                                        ? const Text(
                                            "  - NA",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "  - ₹ ${controller.party?.couples}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                    controller.party?.stag == '0'
                                        ? const Text(
                                            "  - NA",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "  - ₹ ${controller.party?.stag}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                    controller.party?.others == '0'
                                        ? const Text("  - NA",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600))
                                        : Text(
                                            "  - ₹ ${controller.party?.others}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Selected Amenities",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'malgun', fontSize: 18),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.categoryLists.isNotEmpty,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: controller.categoryLists.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final categoryList = controller.categoryLists[index];
                      return categoryList.amenities.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (categoryList.amenities.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      categoryList.title.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 5.0,
                                    children: categoryList.amenities.map((amenity) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: amenity.selected
                                            ? Chip(
                                                label: Text(
                                                  amenity.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.sp,
                                                    fontFamily: 'malgun',
                                                  ),
                                                ),
                                                backgroundColor: amenity.selected
                                                    ? Colors.red.shade900
                                                    : Colors.grey[400],
                                              )
                                            : Container(),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ):loder();
      }
     ),
      bottomSheet: Container(
        height: 1,
        width: Get.width,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottomCenter,
            blastDirection: -pi / 2,
            emissionFrequency: 0.01,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 80,
            gravity: 0.3,
          ),
        ),
      ),
    );
  }

  Widget loder()
  {return Center(
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Lottie.network(
              'https://assets-v2.lottiefiles.com/a/ebf552bc-1177-11ee-8524-57b09b2cd38d/PaP7jkQFk9.json')
        ]),
      )); }
  Widget CustomTextIcon({required IconData icon, required String IconText}) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade900,
            borderRadius: BorderRadius.circular(100.sp),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(
          height: Get.height * 0.003,
        ),
        Text(
          IconText,
          style: TextStyle(
            fontFamily: 'malgun',
            fontSize: 14,
            color: Colors.black,
          ),
        )
      ]),
    );
  }

  Widget customImageSlider(
      {required String partyPhotos, required String imageStatus}) {
    return Container(
      height: Get.height * 0.295,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(15),
        image:
            DecorationImage(image: NetworkImage(partyPhotos), fit: BoxFit.fill),
      ),
      width: Get.width,
      /* child: Image.network(
                        controller.party?.coverPhoto,
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        },
                      ), */
    );
  }

  joinPartyFormDialouge({required BuildContext context}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*   TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Enter any text";
                        },
                        decoration:
                        InputDecoration(hintText: "Please Enter Text"),
                      ),*/
                  /*   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Choice Box"),
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked;
                                });
                              })
                        ],
                      )*/
                  Center(
                    child: Text(
                      '${getSingleParty?.title.capitalizeFirst}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Text(
                    'Date : ${getSingleParty?.prStartDate != null ? DateFormat('d MMMM, y').format(DateTime.fromMillisecondsSinceEpoch(int.parse('${getSingleParty?.startDate}') * 1000)) : ''} ',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Text(
                    "Time: ${getSingleParty?.startTime}  to  ${getSingleParty?.endTime}",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87, fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'No of People : ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if(noOfPeople >1){
                              noOfPeople--;
                              }
                              setState(
                                () {},
                              );
                            },
                            child: Icon(CupertinoIcons.minus_circle_fill,
                                color: Colors.red.shade900),
                          ),
                          Text(
                            '  ${noOfPeople.toString()}  ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                              onTap: () {
                                if(noOfPeople<6){
                                noOfPeople++;
                                }
                                setState(
                                  () {},
                                );
                              },
                              child: Icon(CupertinoIcons.plus_circle_fill,
                                  color: Colors.red.shade900))
                        ],
                      )
                    ],
                  ),
                ],
              ),
              title: Container(padding:EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red.shade900),
                child: Text(
                  'Avail this Offer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    fontSize: 13.sp
                  ),
                ),
              ),
              actions: <Widget>[
                Center(
                  child: InkWell(
                    child:
                    Container(
                       // width: 50,
                      padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange),
                        child: Text(
                          '   Book Now   ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                    onTap: () async {
                      /*  if (_formKey.currentState.validate()) {
// Do something like updating SharedPreferences or User Settings etc.

                       */
                    String pj_id =   await APIService.onBookingParty(
                          '${getSingleParty?.id}', noOfPeople.toString());
                  //  var data= APIService.ongoingParty(controller.party?.id);
                    if(pj_id.isNotEmpty){
                      join = 'Booked';
                    }
                    Navigator.of(context).pop();
                      if(pj_id!=''){
                        Get.to(JoinPartyDetails(),arguments: pj_id);
                      }
                    },
                  ),
                ),
              ],
            );
          });
        });
  }
  Widget bookNowButton()
  {
    return GestureDetector(
      onTap: () async {
        logCustomEvent(eventName: bookNow, parameters: {'name':'book Now'});
      if(dashboardController.individualProfileController.coverPhotoURL.isNotEmpty && dashboardController.individualProfileController.bio.isNotEmpty) {
        getSingleParty?.ongoingStatus != 1 ?
       await joinPartyFormDialouge(context: context):
        Fluttertoast.showToast( msg: 'You are already booked this offer',);
          setState(() {});
          join = 'Booked';
          _controllerBottomCenter.play();
      }
      else{
        Get.snackbar('Sorry',
            'Upload your profile photo & Bio to access all the features.');
      }
      },
      child: Container(
        width: Get.width * 0.2,
        height: Get.height * 0.04,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.orange,
        ),
        child: FittedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.add_circled,
                    color: Colors.white),
                SizedBox(
                  width: Get.width * 0.003,
                ),
                getSingleParty?.ongoingStatus == 0
                    ? Text(
                  join,
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                )
                    : Text(
                  "Booked",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                )
              ]),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool sub;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        // color: Colors.red.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          /*  BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),*/
        ],
      ),
      //  padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200),
            child: Icon(
              icon,
              color: Colors.red.shade900,
              size: 22,
            ),
          ),
          SizedBox(
            width: Get.width * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  width: Get.width * 0.5,
                  child: Text(
                    title.capitalizeFirst!,
                    style: const TextStyle(
                      fontFamily: 'malgun',
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              sub == true
                  ? FittedBox(
                      child: Container(
                        width: Get.width * 0.5,
                        child: Text(
                          subtitle,
                          maxLines: 3,
                          style: const TextStyle(
                            fontFamily: 'malgun',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}

class TitleAnswerWidget extends StatelessWidget {
  final String title;
  final String answer;

  const TitleAnswerWidget(
      {super.key, required this.title, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.2),
            ),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BoostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final color;

  const BoostButton(
      {Key? key,
      required this.color,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
