import 'dart:convert';
import 'dart:io';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';
import 'package:partypeopleindividual/individual_profile_screen/profilephotoview.dart';

import 'package:partypeopleindividual/widgets/custom_loading_indicator.dart';

import 'package:partypeopleindividual/widgets/individual_amenities.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:partypeopleindividual/widgets/pop_up_dialogs.dart';
import 'package:shimmer/shimmer.dart';

import '../centralize_api.dart';
import '../edit_individual_profile/edit_individual_profile.dart';
import '../widgets/active_city_select.dart';
import '../widgets/cached_image_placeholder.dart';
import '../widgets/calculate_age.dart';
import '../widgets/custom_images_slider.dart';
import '../widgets/custom_textview_profile.dart';

class IndividualProfileScreenView extends StatefulWidget {
  const IndividualProfileScreenView({super.key});

  @override
  State<IndividualProfileScreenView> createState() =>
      _IndividualProfileScreenViewState();
}

class _IndividualProfileScreenViewState
    extends State<IndividualProfileScreenView> {
  File? _coverImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  double _progress = 0;
  List<Category> _categories = [];
  List<CategoryList> _categoryLists = [];

  Future<void> _fetchData() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            API.individualOrganizationAmenities),
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
    print(individualProfileController.getPrefiledData);
    for (var i = 0;
        i < individualProfileController.getPrefiledData.length;
        i++) {
      var amenityName = individualProfileController.getPrefiledData[i];
      print(amenityName);
      setState(() {
        _categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.id == amenityName) {
              if (individualProfileController.selectedAmenities
                  .contains(amenity.id)) {
              } else {
                individualProfileController.selectedAmenities.add(amenity.id);
              }
              amenity.selected = true;
            }
          });
        });
      });
    }
  }

  void _selectAmenity(Amenity amenity) {
    setState(() {
      if (amenity.selected) {
        // amenity is already selected, remove it from the list
        individualProfileController.selectedAmenities.remove(amenity.id);
      } else {
        // amenity is not selected, add it to the list
        individualProfileController.selectedAmenities.add(amenity.id);
      }
      amenity.selected = !amenity.selected;
    });
  }

  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());

  Future<void> futureInit() async {
    await individualProfileController.individualProfileData();
    individualProfileController.getProfileImages();
    await _fetchData();
  }

  @override
  void initState() {
    futureInit();
    super.initState();
  }

  APIService apiService = Get.put(APIService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: LoadingIndicator(progress: _progress),
            )
          : Obx(
              () => apiService.isLoading.value == true
                  ? Center(
                      child: LoadingIndicator(progress: _progress),
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                //Cover Photo
                                Card(elevation: 5,
                                  //color: Colors.orange,
                                  clipBehavior:Clip.hardEdge ,
                                  margin: EdgeInsets.only(bottom: 25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),),
                                  child:
                                  CarouselSlider(items:
                                  individualProfileController.profileImages.map((PartyImageWithstatus element) =>
                                     CustomImageSlider(partyPhotos: element.image, imageStatus: element.status)
                                    ).toList(),
                                    options: CarouselOptions(
                                        height: Get.height*0.4,
                                        // enlargeCenterPage: true,
                                        autoPlay: true,
                                        //aspectRatio: 16 / 9,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enableInfiniteScroll: true,
                                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                                        viewportFraction: 1,

                                    ),
                                  ),
                                ),

                             /*   Container(
                                        height: Get.height * 0.35,
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
                                          imageUrl:  individualProfileController
                                              .coverPhotoURL.value,
                                          width: Get.width,
                                          fit: BoxFit.cover,
                                        ),

                                      ),*/
                                // Profile Photo
                                Positioned(
                                  bottom: 30,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => ProfilePhotoView(
                                            profileUrl:
                                                individualProfileController
                                                    .profilePhotoURL.value,
                                        approvalStatus: '1',
                                          ));
                                    },
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
                                      child:
                                      Container(
                                        height: Get.height * 0.11,
                                        width:  Get.height * 0.11,
                                            child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        child: Blur(blur:individualProfileController
                                            .photoStatusApproval.value !=
                                            '1'? 2.5:0,
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey.shade200,
                                                highlightColor: Colors.grey.shade400,
                                                period: const Duration(milliseconds: 1500),
                                                child:  Container(
                                                  height: Get.height * 0.35,
                                                  color: Color(0xff7AB02A),
                                                ),
                                              ),
                                              imageUrl: individualProfileController
                                                  .profilePhotoURL
                                                  .value
                                                  .isEmpty
                                                  ? 'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f'
                                                  : individualProfileController
                                                  .profilePhotoURL
                                                  .value,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                          ),
                                          overlay: individualProfileController
                                              .photoStatusApproval.value !=
                                              '1'? Container():
                                          CachedNetworkImage(
                                            placeholder: (context, url) => Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.grey.shade400,
                                              period: const Duration(milliseconds: 1500),
                                              child:  Container(
                                                height: Get.height * 0.35,
                                                color: Color(0xff7AB02A),
                                              ),
                                            ),
                                            imageUrl: individualProfileController
                                                .profilePhotoURL
                                                .value
                                                .isEmpty
                                                ? 'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fdefault-cover-4.jpg?alt=media&token=adba2f48-131a-40d3-b9a2-e6c04176154f'
                                                : individualProfileController
                                                .profilePhotoURL
                                                .value,
                                            width: Get.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                          )



                                      // CircleAvatar(
                                      //         radius: 55,
                                      //         backgroundImage:(individualProfileController
                                      //                         .profilePhotoURL
                                      //                         .value
                                      //                         .isNotEmpty
                                      //                     ? NetworkImage(
                                      //                         individualProfileController
                                      //                             .profilePhotoURL
                                      //                             .value)
                                      //                     : const AssetImage(
                                      //                         'assets/images/man.png'))
                                      //                 as ImageProvider<Object>?,
                                      //       ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: Get.height*0.05,
                                  left: Get.width*0.03,
                                  child:
                                  getBackBarButton(context: context),
                                ),
                                // Edit Button for Profile Photo
                                /*   Positioned(
                      bottom: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: (){Get.to(EditIndividualProfile()); },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ), */
                              ],
                            ),

                            ///Other Individual Widget
                            Container(margin: EdgeInsets.only(left: 10),
                              child: LinearPercentIndicator(
                                barRadius: Radius.circular(10),
                                width: Get.width*0.72,
                                lineHeight: Get.height*0.035,
                                leading:  Lottie.asset(
                                    'assets/images/sad_emoji.json',
                                    // controller: _animationController,
                                    height: 40,
                                    width: 40,
                                    animate: true,
                                    fit: BoxFit.cover
                                  //fit: BoxFit.cover
                                ),
                                animationDuration: 2000,
                                progressColor: individualProfileController
                                    .profilePercentComplete.value >= 60.0 ? Colors.red.shade900 :individualProfileController
                                    .profilePercentComplete.value >= 30.0 ? Colors.red.shade600 :Colors.red.shade200,
                                animation: true,
                                percent: individualProfileController
                                    .profilePercentComplete.value/100,
                                center: Text(
                                  individualProfileController
                                      .profilePercentComplete.value.toString(),
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                trailing: Lottie.asset(
                                    'assets/images/happy_emoji.json',
                                    // controller: _animationController,
                                    height: 45,
                                    width: 45,
                                    animate: true,
                                    fit: BoxFit.cover
                                  //fit: BoxFit.cover
                                ),
                                backgroundColor: Colors.grey,
                                // progressColor: Colors.blue,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomProfileTextView(
                                      text: individualProfileController
                                          .firstname.value.capitalizeFirst.toString(),
                                      icon: Icons.person),
                                ),
                                Expanded(
                                  child: CustomProfileTextView(
                                      text: individualProfileController
                                          .lastname.value.capitalizeFirst
                                          .toString(),
                                      icon: Icons.person),
                                ),
                              ],
                            ),
                             Blur(
                              blur:  2.5,
                              child: CustomTextFieldview(
                                  individualProfileController
                                      .description.value.capitalizeFirst
                                      .toString(),
                                  Icons.description),
                              overlay: individualProfileController
                                  .descStatusApproval.value ==
                                  '0'
                                  ? Container():CustomTextFieldview(
                                  individualProfileController
                                      .description.value.capitalizeFirst
                                      .toString(),
                                  Icons.description)
                            ),

                            Row(
                              children: [
                                Visibility(visible: individualProfileController.dob.value !='0000-00-00'?true:false ,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: CalculateAge.calAge(
                                            individualProfileController
                                                    .dob.value ??
                                                ""),
                                        icon: Icons.calendar_month),

                                    /*  CustomDateField(
                        validate: true,
                        hintText: 'Date of Birth',
                        icon: Icons.calendar_today,
                        controller: individualProfileController
                            .dobController,
                      ), */
                                  ),
                                ),

                                Expanded(
                                  child: CustomProfileTextView(
                                      text: individualProfileController
                                          .gender.value,
                                      icon: Icons.calendar_month),

                                  //GenderSelect(),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Visibility(
                                  visible:  individualProfileController
                                      .occupation.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .qualification.value,
                                        icon: Icons.description_outlined),
                                    //QualificationWidget(),
                                  ),
                                ),
                                Visibility(
                                  visible:  individualProfileController
                                      .occupation.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .occupation.value,
                                        icon: Icons.work),

                                    //OccupationWidget(),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Visibility(
                                  visible:  individualProfileController
                                      .country.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .country.value,
                                        icon: Icons.location_on),
                                    //QualificationWidget(),
                                  ),
                                ),
                                Visibility(
                                  visible:  individualProfileController
                                      .state.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .state.value,
                                        icon: Icons.location_on),

                                    //OccupationWidget(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible:  individualProfileController
                                      .city.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .city.value,
                                        icon: Icons.location_city),
                                    //QualificationWidget(),
                                  ),
                                ),
                                Visibility(
                                   visible:  individualProfileController
                                        .pincode.value.isNotEmpty,
                                  child: Expanded(
                                    child: CustomProfileTextView(
                                        text: individualProfileController
                                            .pincode.value,
                                        icon: Icons.pin_drop),

                                    //OccupationWidget(),
                                  ),
                                ),
                              ],
                            ),

                            /* SelectState(
                    onCountryChanged: (onCountryChanged) {},
                    onStateChanged: (onCountryChanged) {},
                    onCityChanged: (onCityChanged) {}),
                */
                            Container(
                              padding: EdgeInsets.only(
                                top: 10.0,
                              ),
                              margin: EdgeInsets.all(15),
                              // adjust padding as needed
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preferred Location",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  Text(
                                    "* Preferred Location is the location where you want to explore parties & party mates. *",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomProfileTextView(
                                    text: individualProfileController
                                        .activeCity.value,
                                    icon: Icons.location_city_sharp,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            /*  const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              // adjust padding as needed
                              child: Text(
                                "Update Amenities",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),*/

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
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    amenity.selected
                                                                        ? Colors
                                                                            .red.shade900
                                                                        : Colors
                                                                            .grey[400],
                                                              )
                                                            : Visibility(visible: false,
                                                            child: Container()
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
                            /*    apiService.isLoading.value == true
                    ? const CupertinoActivityIndicator(
                  color: Colors.grey,
                  radius: 10,
                ) // Show loading indicator while API call is in progress
                    : CustomButton(
                  width: Get.width * 0.6,
                  text: 'Update',
                  onPressed: individualProfileController
                      .onUpdateButtonPressed,
                ),
                */

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget customImageSlider({required String partyPhotos, required String imageStatus})
  {
    return
      Blur(blur: 5.0,
        child: Container(
          height: Get.height*0.4,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15),
           // image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.cover),
          ),
          width: Get.width,
          child: CachedNetworkImageWidget(
            imageUrl: partyPhotos,
            fit: BoxFit.fill,
            height: Get.height*0.4,
            width: Get.width,
            errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline),
            placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(
                    color: Colors.white, radius: 15)),
          ),
        ),
        overlay:imageStatus =='1' ?Container(
          height: Get.height*0.4,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15),
           // image:DecorationImage( image: NetworkImage(partyPhotos),fit: BoxFit.cover),
          ),
            child: CachedNetworkImageWidget(
              imageUrl: partyPhotos,
              fit: BoxFit.fill,
              height: Get.height*0.4,
              width: Get.width,
              errorWidget: (context, url, error) =>
              const Icon(Icons.error_outline),
              placeholder: (context, url) => const Center(
                  child: CupertinoActivityIndicator(
                      color: Colors.white, radius: 15)),
            ),
          width: Get.width,
        ):Container() ,


      );
  }
  Widget CustomTextFieldview(String text, IconData icon) {
    return Container(
      constraints: BoxConstraints(),
     // height: Get.height * 0.2,
      child: Neumorphic(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.red.shade900),
              SizedBox(
                width: Get.width * 0.03,
              ),
              Container(
                width: Get.width * 0.75,
                child: Text(
                  text,
                  //maxLines: 5,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    individualProfileController.profileImages.clear();
    super.dispose();
  }
}
