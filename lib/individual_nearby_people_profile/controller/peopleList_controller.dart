import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api_helper_service.dart';
import '../../individualDashboard/controllers/individual_dashboard_controller.dart';
import '../../individualDashboard/models/usermodel.dart';
import '../../individual_profile/controller/individual_profile_controller.dart';

class PeopleListController extends GetxController
{
  RxList<UserModel> paginatedUsersList = RxList<UserModel>();
  RxString noUserFoundPaginationController = "null".obs;
  int start=0;
  int end=0;
  int gender = 0;
  APIService apiService = Get.find();
  IndividualDashboardController individualDashboardController =
  Get.put(IndividualDashboardController());
  IndividualProfileController individualProfileController = Get.find();

  final refreshController= RefreshController(initialRefresh: true);
  RxBool showAnimatedHeart = false.obs;
  List<UserModel> maleList = [];
  List<UserModel> femaleList = [];
  List<UserModel> AllList = [];
  List<UserModel> showList = [];
  List<UserModel> otherList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //getDataForDashboard();

  }

  void getMaleFemaleList() {
    maleList.clear();
    femaleList.clear();
    otherList.clear();
  paginatedUsersList.forEach((element) {

      if (element.gender == 'Male') {
        maleList.add(element);
      } else if (element.gender == 'Female') {
        femaleList.add(element);
      } else {
        otherList.add(element);
      }
    });
  }


  Future<void> getPaginatedNearbyPeoples({required bool isRefresh , required int type}) async {
    gender=type;
    String state = GetStorage().read('state');
    String city = '';
    if (individualProfileController.activeCity.value.toString().isNotEmpty) {
      city = individualProfileController.activeCity.value.toString();
    } else {
      city = 'delhi';
    }
    if(isRefresh){
      start = 1;
      end = 15;
      paginatedUsersList.clear();
    }else {
      start =  ++end;
      end = end + 15;
    }
    try {
      var response = await apiService.individualNearbyPeoples(
        {
          'city_id': city.toLowerCase(),
          'state': state.toLowerCase(),
          'start':start.toString(),
          'end':end.toString(),
          if(type==1) 'gender':'male',
          if(type==2)'gender':'female',
        },
        '${GetStorage().read('token')}',
      );

      if (response['status'] == 1 && response['message'].contains('Success')) {
        var usersData = response['data'] as List;

        paginatedUsersList.addAll(usersData.map((user) => UserModel.fromJson(user)));
        showList.clear();
        maleList.clear();
        femaleList.clear();
        otherList.clear();
        showList = [...paginatedUsersList];

        //getMaleFemaleList();

        if(usersData.isEmpty){
          start = start-15;
          end = end-15;
        }
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        update();
      } else if (response['status'] == 0 &&
          response['message'].contains('Not')) {
        noUserFoundPaginationController.value = response['message'];
        start = start-15;
        end = end-15;
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        update();

        Get.snackbar('Opps!', 'No User found ');
      } else {
        start = start-15;
        end = end-15;
        if(isRefresh){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
        Get.snackbar('Opps!', 'No User found ');
      }
    } catch (e) {
      noUserFoundPaginationController.value = 'No User';
      start = start-15;
      end = end-15;
      if(isRefresh){
        refreshController.refreshCompleted();
      }else{
        refreshController.loadComplete();
      }
      update();
    }
  }

  Future<void> getDataForDashboard() async {
    await getPaginatedNearbyPeoples(isRefresh: false , type: 0);
    //getMaleFemaleList();
  }

}