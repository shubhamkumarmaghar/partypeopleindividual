import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../centralize_api.dart';
import '../../individualDashboard/controllers/individual_dashboard_controller.dart';
import '../../individualDashboard/models/usermodel.dart';
import '../../individualDashboard/views/nearby_people_profile.dart';
import '../../individual_nearby_people_profile/view/individual_people_profile.dart';
import '../controller/peopleList_controller.dart';

class PeopleList extends StatefulWidget {
  final List<UserModel> peopleList;

  PeopleList({Key? key, required this.peopleList}) : super(key: key);

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList>
    with SingleTickerProviderStateMixin {
  PeopleListController _peopleListController = Get.put(PeopleListController());
  int choiceIndex = 0;
  Timer? _debounce;
  TextEditingController? _textEditingController;


  @override
  void initState() {
    super.initState();
    //_peopleListController.getMaleFemaleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PeopleListController>(
        builder: (controllerPeople) {
          return Container(
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
            child: Stack(
              children: [
                CustomScrollView(
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
                            homePageText("People List",
                                top: 30, color: Colors.white),
                            GestureDetector(
                              onTap: ()async {
                                log(_peopleListController.paginatedUsersList.length.toString());
                                await bottomMaleFemale(context);
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
                    SliverToBoxAdapter(
                      child: // search bar
                      Container(
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.1,
                        ),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.sp)),
                                child: TextField(enabled: _peopleListController.individualDashboardController
                                    .approvalStatus.value != '1' ? false :true,
                                  controller: _textEditingController,
                                  onChanged: (value) {
                                    log('value $value');
                                    _onSearchChanged(value);
                                  },
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Container(
                                        margin: EdgeInsets.only(left: 15),
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
                    SliverPadding(padding: EdgeInsets.only(top: 20,bottom: 10),
                      sliver: SliverToBoxAdapter(child: Container(
                        height: Get.height*0.8,
                        child: SmartRefresher(
                            controller: controllerPeople.refreshController,
                            enablePullDown: true,
                            enablePullUp: true,
                            onRefresh: () {
                              controllerPeople.getPaginatedNearbyPeoples(isRefresh: true ,type: controllerPeople.gender);
                            },
                            onLoading:  () {
                              controllerPeople.getPaginatedNearbyPeoples(isRefresh: false,type:controllerPeople.gender);
                            },
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.04,
                              ),
                              itemCount: controllerPeople.showList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (_peopleListController.individualDashboardController
                                        .approvalStatus.value ==
                                        '1') {
                                      Get.to(() => IndividualPeopleProfile(),
                                          arguments: controllerPeople.showList[index].id);
                                    }
                                    else {
                                      Get.snackbar('Sorry!',
                                          'Your account is not approved , please wait until it got approved');
                                    }

                                  },
                                  child: NearByPeopleProfile(
                                    imageURL: controllerPeople.showList[index].profilePicture,
                                    name: controllerPeople.showList[index].username,
                                    id: controllerPeople.showList[index].id,
                                    likeStatus: controllerPeople.showList[index].likeStatus,
                                    onlineStatus: controllerPeople.showList[index].onlineStatus,
                                    privacyStatus: controllerPeople.showList[index].privacyOnline,
                                    profile_pic_approval_status: controllerPeople.showList[index].profilePicApproval,
                                    lastSeen:controllerPeople.showList[index].lastSeen,
                                  ),
                                  // personGrid(index: index),
                                );
                              },
                            )
                        ),
                      ),),),

                    // SliverPadding(
                    //     padding:
                    //         EdgeInsets.only(left: 1, right: 8, top: 8, bottom: 8),
                    //     sliver: SliverGrid(
                    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 3,
                    //         mainAxisSpacing: 10,
                    //         crossAxisSpacing: 10,
                    //         childAspectRatio: 1.04,
                    //       ),
                    //       delegate: SliverChildBuilderDelegate(
                    //           childCount: showList.length,
                    //           (BuildContext context, int index) {
                    //         return GestureDetector(
                    //           onTap: () {
                    //             Get.to(() => IndividualPeopleProfile(),
                    //                 arguments: showList[index].id);
                    //           },
                    //           child: NearByPeopleProfile(
                    //             imageURL: showList[index].profilePicture,
                    //             name: showList[index].username,
                    //             id: showList[index].id,
                    //             likeStatus: showList[index].likeStatus,
                    //             onlineStatus: showList[index].onlineStatus,
                    //             privacyStatus: showList[index].privacyOnline,
                    //             profile_pic_approval_status:
                    //                 showList[index].profilePicApproval,
                    //           ),
                    //           // personGrid(index: index),
                    //         );
                    //       }),
                    //     )),
                  ],
                ),
                // SmartRefresher(
                //     controller: _dashboardController.refreshController,
                //     onRefresh: () {
                //       _dashboardController.getPaginatedNearbyPeoples(isRefresh: true);
                //     },
                //     onLoading:  () {
                //       _dashboardController.getPaginatedNearbyPeoples(isRefresh: false);
                //     },
                //     child: GridView.builder(
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         mainAxisSpacing: 10,
                //         crossAxisSpacing: 10,
                //         childAspectRatio: 1.04,
                //       ),
                //       itemCount: _dashboardController.paginatedUsersList.length,
                //       itemBuilder: (BuildContext context, int index) {
                //         return GestureDetector(
                //           onTap: () {
                //             Get.to(() => IndividualPeopleProfile(),
                //                 arguments: _dashboardController.paginatedUsersList[index].id);
                //           },
                //           child: NearByPeopleProfile(
                //             imageURL: _dashboardController.paginatedUsersList[index].profilePicture,
                //             name: _dashboardController.paginatedUsersList[index].username,
                //             id: showList[index].id,
                //             likeStatus: _dashboardController.paginatedUsersList[index].likeStatus,
                //             onlineStatus: _dashboardController.paginatedUsersList[index].onlineStatus,
                //             privacyStatus: _dashboardController.paginatedUsersList[index].privacyOnline,
                //             profile_pic_approval_status:
                //             _dashboardController.paginatedUsersList[index].profilePicApproval,
                //           ),
                //           // personGrid(index: index),
                //         );
                //       },
                //     )
                // ),
                GetBuilder<PeopleListController>(
                  builder: (controller) {
                    return Container(
                        height: Get.height,
                        width: Get.width,
                        child: controller.showAnimatedHeart.value
                            ? Align(
                          alignment: Alignment.center,
                          child: Lottie.network(
                            // 'https://assets-v2.lottiefiles.com/a/3073e56e-1175-11ee-911b-eb7a8cb4524d/VyuILSK8xC.json'
                              'https://assets-v2.lottiefiles.com/a/c543ac62-1150-11ee-953b-235b9373fc03/85XdRr7LQN.json'),
                        )
                            : Container());
                  },
                )
              ],
            ),
          );
        },
      )
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

  Future bottomMaleFemale(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return GetBuilder<FilterChipController>(
            init: FilterChipController(),
            builder: (controllerChip) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  iconText(
                    Icons.people_outline,
                    'All People',
                    FilterChip(
                        label: Text('All People'),
                        selected: controllerChip.list[0],
                        selectedColor: Colors.red.shade900,
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                        onSelected: (value) {
                          controllerChip.setChip(selectedIndex: 0);
                          _peopleListController.getPaginatedNearbyPeoples(isRefresh: true ,type: 0);
                         // _peopleListController.showList = _peopleListController.paginatedUsersList;
                          navigator?.pop();
                          setState(() {});
                        }),
                  ),
                  iconText(
                    Icons.male,
                    'Male',
                    FilterChip(
                        label: Text('Male'),
                        selectedColor: Colors.red.shade900,
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                        selected: controllerChip.list[1],
                        onSelected: (value) {
                          controllerChip.setChip(selectedIndex: 1);
                          _peopleListController.getPaginatedNearbyPeoples(isRefresh: true ,type: 1);
                        //  _peopleListController.showList = _peopleListController.maleList;
                          navigator?.pop();
                          setState(() {});
                        }),
                  ),
                  iconText(
                    Icons.female,
                    'Female',
                    FilterChip(
                        label: Text('Female'),
                        selected: controllerChip.list[2],
                        selectedColor: Colors.red.shade900,
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                        onSelected: (value) {
                          controllerChip.setChip(selectedIndex: 2);
                          _peopleListController.getPaginatedNearbyPeoples(isRefresh: true ,type: 2);
                         // _peopleListController.showList = _peopleListController.femaleList;
                          navigator?.pop();
                          setState(() {});
                        }),
                  ),
                ],
              );
            },
          );
        });
  }

  Widget iconText(IconData icon, String text, Widget widget) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(children: [
        Icon(icon),
        SizedBox(
          width: Get.width * 0.05,
        ),
        widget
      ]),
    );
  }

  _onSearchChanged(String query) {
    if (query != '') {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 2000), () async {
        final response = await http.post(
          Uri.parse(API.getUserSearch),
          headers: <String, String>{
            'x-access-token': '${GetStorage().read('token')}',
          },
          body: <String, String>{'keyword': query},
        );
        if (response.statusCode == 200) {
          // If the server returns a 200 OK response,
          // then parse the JSON.
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print(jsonResponse);

          if (jsonDecode(response.body)['status'] == 1) {
            var usersData = jsonDecode(response.body)['data'] as List;
            _peopleListController.showList.clear();
            _peopleListController.maleList.clear();
            _peopleListController.femaleList.clear();
            _peopleListController.otherList.clear();
            _peopleListController.showList.addAll(usersData.map((user) => UserModel.fromJson(user)));
            _peopleListController.getMaleFemaleList();
            setState(() {});
            log('User data found $query ${jsonDecode(response.body)['data'][0]['id']}');
            // String id = jsonDecode(response.body)['data'][0]['id'].toString();
            //Get.to(IndividualPeopleProfile(),arguments: id);
          } else {
            print('data not found');
            Get.snackbar(
                'Oops!', 'No User Found with this username, try another');
          }
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('data not found');
        }
      });
    }
  }
}

class MyFilterChip extends StatefulWidget {
  const MyFilterChip(
      {super.key,
      required this.onChanged,
      required this.text,
      required this.status});

  final void Function(bool) onChanged;
  final String text;
  final bool status;

  @override
  State<MyFilterChip> createState() => MyFilterChipState();
}

class MyFilterChipState extends State<MyFilterChip> {
  bool _selected = false;

  void selectedStatus() {
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

class FilterChipController extends GetxController {
  List<bool> list = [true, false, false];

  void setChip({required int selectedIndex}) {
    list = list.map((e) => false).toList();
    list[selectedIndex] = true;
    update();
  }
}
