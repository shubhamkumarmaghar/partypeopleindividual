import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/api_helper_service.dart';

import '../../centralize_api.dart';
import '../../individualDashboard/models/city.dart';
import '../../widgets/payment_response_view.dart';
import '../../widgets/select_photo_optionsScreen.dart';
import '../../widgets/submit_application.dart';

class IndividualProfileController extends GetxController {
  List<PartyImageWithstatus> profileImages =[];
  RxInt profilePhotoSelectNo = 0.obs;
  RxString coverPhotoURL = ''.obs;
  RxString profilePhotoURL = ''.obs;
  RxString profileB = ''.obs;
  RxString profileE = ''.obs;
  RxString profileC = ''.obs;
  RxString profileD = ''.obs;
  File coverImage = File('');
  File profileImage = File('');
  File imageProfile_c =File('');
  File imageProfile_b = File('');
  File imageProfile_d = File('');
  File imageProfile_e = File('');
  RxString username = ''.obs;
  RxString userMobile = ''.obs;
  RxString userId = ''.obs;
  RxString firstname = ''.obs;
  RxString email = ''.obs;
  RxString lastname = ''.obs;
  RxString bio = ''.obs;
  RxString description = ''.obs;
  RxString dob = ''.obs;
  RxString pincode = ''.obs;
  RxString organization_id = ''.obs;
  RxString occupation = ''.obs;
  RxString qualification = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString gender = ''.obs;
  RxString activeCity = ''.obs;
  RxString city = ''.obs;
  RxString privacyOnlineStatus = ''.obs;
  RxString notification = ''.obs;
  RxString descStatusApproval = ''.obs;
  RxString photoStatusApproval = ''.obs;
  RxString photoStatusApproval_e = ''.obs;
  RxString photoStatusApproval_b = ''.obs;
  RxString photoStatusApproval_c = ''.obs;
  RxString photoStatusApproval_d = ''.obs;



  TextEditingController dobController = TextEditingController();
  RxList selectedAmenities = [].obs;
  RxList activeCities = [].obs;
  RxList<IndividualCity> allCityList = RxList();
  var getPrefiledData;
  Map<String, String> userData = {};

  APIService apiService = Get.put(APIService());


  // Add this function to your controller.
  void onContinueButtonPressed() {
   if (coverImage.path.isEmpty) {
      Get.snackbar('Photo Error', 'Cover Photo URL should not be empty');
      return;
    }
    if (profileImage.path.isEmpty) {
      Get.snackbar('Photo Error', 'Profile Photo URL should not be empty');
      return;
    }
    if (firstname.value.isEmpty) {
      Get.snackbar('Name Error', 'First name should not be empty');
      return;
    }
   if (lastname.value.isEmpty) {
     Get.snackbar('Name Error', 'Last name should not be empty');
     return;
   }
   if (description.value.isEmpty) {
     Get.snackbar('Description Error', 'Description should not be empty');
     return;
   }
   if (gender.value.isEmpty) {
     Get.snackbar('Gender Error', 'Gender should not be empty');
     return;
   }
   /*
    if (email.value.isEmpty || !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Email  should not be empty');
      return;
    }
    if ( !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Please enter valid email ');
      return;
    }

    if (dob.value.isEmpty) {
      Get.snackbar('DOB Error', 'Date of birth should not be empty');
      return;
    }

    // Check pincode length and pattern
    if (pincode.value.isEmpty || pincode.value.length != 6 ||
        !isNumeric(pincode.value)) {
      Get.snackbar('Pincode Error',
          'Pincode should be exactly 6 digits and should not contain non-numeric characters');
      return;
    }

    if (occupation.value.isEmpty) {
      Get.snackbar('Occupation Error', 'Occupation should not be empty');
      return;
    }

    if (qualification.value.isEmpty) {
      Get.snackbar('Qualification Error', 'Qualification should not be empty');
      return;
    }

    if (country.value.isEmpty) {
      Get.snackbar('Location Error', 'Country should not be empty');
      return;
    }

    if (activeCity.value.isEmpty) {
      Get.snackbar('Location Error', 'Active City should not be empty');
      return;
    }

    if (state.value.isEmpty) {
      Get.snackbar('Location Error', 'State should not be empty');
      return;
    }

    if (city.value.isEmpty) {
      Get.snackbar('Location Error', 'City should not be empty');
      return;
    }
*/
    // Your API call goes here. Use Get.isSnackbarOpen to avoid triggering the API call if a snackbar is open.
    if (!Get.isSnackbarOpen && apiService.isLoading.value == false) {
      // individualAPI
      userData = {
        if(coverPhotoURL.value.isNotEmpty && coverImage.path.isEmpty) 'cover_photo': coverPhotoURL.value.toString(),
        if(profilePhotoURL.value.isNotEmpty && profileImage.path.isEmpty) 'profile_photo': profilePhotoURL.value.toString(),
        'name': '${firstname.value.capitalize?.trim().toString()}' + ' ' + '${lastname.value.capitalizeFirst?.trim().toString()}',
        if(description.value.isNotEmpty)'bio': description.value.toString(),
        if(description.value.isNotEmpty)'description':description.value.toString(),
        if(dob.value.isNotEmpty)'dob':dob.value.toString(),
        'email':GetStorage().read('email')??" ",
        if(pincode.value.isNotEmpty)'pincode': pincode.value.toString(),
        if(occupation.value.isNotEmpty)'occupation': occupation.value.toString(),
        if(qualification.value.isNotEmpty)'qualification': qualification.value.toString(),
        if(country.value.isNotEmpty)'country': country.value.toString(),
        if(gender.value.isNotEmpty)'gender': gender.value.toString(),
        'type': '2',
        if(selectedAmenities.isNotEmpty)'amenities_id': selectedAmenities.join(','),
        if(state.value.isNotEmpty)'state': state.value.toString(),
        if(city.value.isNotEmpty)'city': city.value.toString(),
      };
      print("ghhh${userData}");
      individualProfile();
    }
  }

  void onUpdateButtonPressed() {
    if (coverPhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Cover Photo URL should not be empty');
      return;
    }

    if (profilePhotoURL.value.isEmpty) {
      Get.snackbar('Photo Error', 'Profile Photo URL should not be empty');
      return;
    }

    if (firstname.value.isEmpty) {
      Get.snackbar('Name Error', 'First name should not be empty');
      return;
    }

    if (lastname.value.isEmpty) {
      Get.snackbar('Name Error', 'Last name should not be empty');
      return;
    }
/*
    if (description.value.isEmpty) {
      Get.snackbar('Bio Error', 'Bio should not be empty');
      return;
    }
*/
    if (email.value.isEmpty || !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Email  should not be empty');
      return;
    }

    if ( !email.value.contains('@')) {
      Get.snackbar('Email Error', 'Please enter valid email ');
      return;
    }

/*
    if (dob.value.isEmpty) {
      Get.snackbar('DOB Error', 'Date of birth should not be empty');
      return;
    }
*/
    // Check pincode length and pattern
/*    if (pincode.value.isEmpty ||
        pincode.value.length != 6 ||
        !isNumeric(pincode.value)) {
      Get.snackbar('Pincode Error',
          'Pincode should be exactly 6 digits and should not contain non-numeric characters');
      return;
    }
*/
    /*
    if (occupation.value.isEmpty) {
      Get.snackbar('Occupation Error', 'Occupation should not be empty');
      return;
    }

    if (qualification.value.isEmpty) {
      Get.snackbar('Qualification Error', 'Qualification should not be empty');
      return;
    }

    if (country.value.isEmpty) {
      Get.snackbar('Location Error', 'Country should not be empty');
      return;
    }

    if (state.value.isEmpty) {
      Get.snackbar('Location Error', 'State should not be empty');
      return;
    }
*/
   /* if (activeCity.value.isEmpty) {
      Get.snackbar('Location Error', 'Active City should not be empty');
      return;
    }
    if (city.value.isEmpty) {
      Get.snackbar('Location Error', 'City should not be empty');
      return;
    }*/

    // Your API call goes here. Use Get.isSnackbarOpen to avoid triggering the API call if a snackbar is open.
    if (!Get.isSnackbarOpen && apiService.isLoading.value == false) {
      // individualAPI
      userData = {
        'cover_photo': coverPhotoURL.value.toString(),
        'profile_photo': profilePhotoURL.value.toString(),
        'name': '${firstname.value.capitalizeFirst?.trim().toString()}' + ' ' + '${lastname.value.capitalizeFirst?.trim().toString()}',
        'organization_id': organization_id.value.toString(),
        if(description.value.isNotEmpty)'bio': description.value.toString(),
        if(description.value.isNotEmpty)'description':description.value.toString(),
        if(dob.value.isNotEmpty)'dob':dob.value.toString(),
        if(email.value.isNotEmpty)'email':email.value.toString(),
        if(pincode.value.isNotEmpty)'pincode': pincode.value.toString(),
        if(occupation.value.isNotEmpty)'occupation': occupation.value.toString(),
        if(qualification.value.isNotEmpty)'qualification': qualification.value.toString(),
        if(country.value.isNotEmpty)'country': country.value.toString(),
        if(gender.value.isNotEmpty)'gender': gender.value.toString(),
        'type': '2',
        if(selectedAmenities.isNotEmpty)'amenities_id': selectedAmenities.join(','),
        if(state.value.isNotEmpty)'state': state.value.toString(),
        if(city.value.isNotEmpty)'city': city.value.toString(),
      };

      individualProfileUpdate();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> individualProfile() async {
    try {
  /*    var response = await apiService.individualProfileCreation(
          userData, '${GetStorage().read('token')}');
      print(response);*/
      var headers = {
        'x-access-token': '${GetStorage().read('token')}',
        // 'Cookie': 'ci_session=53748e98d26cf6811eb0a53be37158bf0cbe5b4b'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse(API.individualProfileCreation));
      request.fields.addAll(userData);
      if (coverImage.path.isNotEmpty) {
        final imga = await http.MultipartFile.fromPath(
          'cover_photo', coverImage.path,);
        request.files.add(imga);
      }
      if (profileImage.path.isNotEmpty) {
        final imgb = await http.MultipartFile.fromPath(
          'profile_photo', profileImage.path,);
        request.files.add(imgb);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

    //  log('abcde ${json.decode(await response.stream.bytesToString())}' );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        //isLoading.value = false;
log('hhhhhhhhhhhh $jsonResponse');
        if (jsonResponse['status'] == 1 && jsonResponse['message'].contains('Successfully')) {
          GetStorage().write('loggedIn', '1');
          individualProfileController.apiService.updateActiveCity(
              individualProfileController.organization_id.value,
              activeCity.value.isNotEmpty
                  ? activeCity.value.toString()
                  : "Delhi");
          Get.offAll(const ShowSubmitMessage());
        }
        else if (jsonResponse['status'] == 2 && jsonResponse['message'].contains('Organization Already Created.'))
        {
          Get.snackbar('Error', 'Organization Already Created.');
        } else {
          Get.snackbar('Error', 'Response or response body is null');
        }
      }
    }
      on SocketException {
        log(
            'Network Error : Please check your internet connection and try again!');
      }
      on HttpException {
        log('Http Error Could not find the service you were looking for!');
      }
      on FormatException {
        log('Error Bad response format. Please contact support!');
      } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
      /*   Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');*/
      print('Unexpected error: $e');
    }

  }

  Future<void> individualProfileUpdate() async {
    print('Individual Profile Update :=> $userData');
    try {
      var response = await apiService.individualProfileUpdate(
          userData, '${GetStorage().read('token')}');
      print(response);

      if (response['status'] == 1 &&
          response['message'].contains('Successfully')) {
        Get.offAll(const ShowSubmitMessage());
      } else if(
      response['status'] == 2 &&
          response['message'].contains('Organization Already Created.')
      ){
        Get.snackbar('Error', 'Organization Already Created.');
      }
      else{
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
     log('Network Error : Please check your internet connection and try again!');
    } on HttpException {
      log('Error Could not find the service you were looking for!');
    } on FormatException {
      log('Error Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
    /*  Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!'); */
      print('Unexpected error: $e');
    }
  }

  Future<void> individualProfileData() async {
    try {
      apiService.isLoading.value = true;
      var response = await apiService
          .individualProfileData('${GetStorage().read('token')}');
      print("profile data $response");

      if (response['status'] == 1 &&
          response['message'].contains('Data Found')) {
        try {
          // Try to parse and assign the values
          Map<String, dynamic> user = response['data'][0];

          // Splitting full name into first and last name
          String fullName = user['name'] ?? ' ';
          List<String> nameParts = fullName.split(' ');

          firstname.value = nameParts[0];
          lastname.value = nameParts.length > 1 ? nameParts[1] : '';

          // Assigning the retrieved data to the respective fields
          bio.value = user['bio'] ?? '';
          description.value = user['description'];
          dob.value = user['dob'] ?? '';
          email.value = user['email'] ?? '';
          pincode.value = user['pincode'] ?? '';
          occupation.value = user['occupation'] ?? '';
          qualification.value = user['qualification'] ?? '';
          country.value = user['country'] ?? '';
          state.value = user['state'] ?? '';
          GetStorage().write('state', state.value);
          username.value = response['user_name'];
          userMobile.value = response['user_phone_number'];
          userId.value = user['user_id'];
          gender.value = user['gender'] ?? '';
          GetStorage().write("myGender", gender.value.toString());
          getPrefiledData = user['org_amenitie_id']?.split(',');
          print("indi amen :=> $getPrefiledData");
          city.value = user['city'] ?? '';
          profilePhotoURL.value = user['profile_pic'] ?? '';
          coverPhotoURL.value = user['cover_photo'] ?? '';
          profileB.value = user['profile_pic_b'] ?? '';
          profileC.value = user['profile_pic_c'] ?? '';
          profileD.value = user['profile_pic_d'] ?? '';
          profileE.value = user['profile_pic_e'] ?? '';
          organization_id.value = user['id'] ?? "";
          activeCity.value = user['active_city']??'Delhi';
          descStatusApproval.value = user['approval_desciption_status']??'';
          photoStatusApproval.value = user['profile_pic_approval_status']??'';
          photoStatusApproval_b.value = user['profile_pic_b_status']??'';
          photoStatusApproval_c.value = user['profile_pic_c_status']??'';
          photoStatusApproval_d.value = user['profile_pic_d_status']??'';
          photoStatusApproval_e.value = user['profile_pic_e_status']??'';
          // Set dobController's text to the 'dob' value
          DateTime date =  DateTime.parse('${dob.value}');
          log('date $date');
          dob.value = DateFormat('dd/MM/yyyy').format(date);
          dobController.text = dob.value;
         // dobController.text = dob.value;
          privacyOnlineStatus.value = response['privacy_online']??'';
          notification.value = response['notification']??'';
          GetStorage().write("my_username", username.value.toString());
          GetStorage().write("my_user_id", userId.value.toString());
          // get status for privacy and notification

          if (privacyOnlineStatus.value
              .toString() ==
              'No') {
            GetStorage().write("privacy_online_status", true);
          } else {
            GetStorage().write("privacy_online_status", false);
          }
         // print("privacy_online_status   ${GetStorage().read("privacy_online_status")}  ${privacyOnlineStatus.value}");
          if (notification.value == 'off') {
            GetStorage().write("online_notification_status", false);
          } else {
            GetStorage().write("online_notification_status", true);
          }

        //  print("online_notification_status   ${GetStorage().read("online_notification_status")}   ${notification.value}");

         log('descStatusApproval ::: ${descStatusApproval.value}');
          apiService.isLoading.value = false;
          update();
        } catch (e) {
          // Log the error or handle it appropriately
          print('Failed to parse user data: $e');

          // Set the fields to their default values
          firstname.value = '';
          lastname.value = '';
          bio.value = '';
          description.value = '';
          dob.value = '';
          pincode.value = '';
          occupation.value = '';
          qualification.value = '';
          country.value = '';
          state.value = '';
          gender.value = '';
          photoStatusApproval.value ='';
          descStatusApproval.value ='';
          city.value = '';
          profilePhotoURL.value = '';
          coverPhotoURL.value = '';
          profileB.value ='';
          profileC.value ='';
          profileE.value ='';
          profileB.value ='';
          activeCity.value = '';
          dobController.text = '';
          apiService.isLoading.value = false;
        }

        update();
      }
      else if(
      response['status'] == 2 &&
          response['message'].contains('Organization Already Created.')
      ){
        Get.snackbar('Error', 'Organization Already Created.');
      }else {
        Get.snackbar('Error', 'Response or response body is null');
      }
    } on SocketException {
  log('Network Error Please check your internet connection and try again!');
    } on HttpException {
      log('Http Error Could not find the service you were looking for!');
    } on FormatException {
      log('Error Bad response format. Please contact support!');
    } catch (e) {
      // If the exact error type isn't matched in the preceding catch clauses
     /* Get.snackbar('Unexpected Error',
          'Something unexpected happened. Try again later!');

      */
      print('Unexpected error: $e');
    }
  }
  void getProfileImages()
  {
    if( coverPhotoURL.value!='' ){
      profileImages.add(PartyImageWithstatus(image: coverPhotoURL.value, status: photoStatusApproval.value));
    //  profileImages.add(coverPhotoURL.value);
    }
    if(profilePhotoURL.value !='' ){
      profileImages.add(PartyImageWithstatus(image: profilePhotoURL.value, status: photoStatusApproval.value));
     // profileImages.add(profilePhotoURL.value);
    }
    if( profileB.value!=''){
      profileImages.add(PartyImageWithstatus(image: profileB.value, status: photoStatusApproval_b.value));
     // profileImages.add(profileB.value);
    }
    if( profileC.value !='' ){
      //profileImages.add(profileC.value);
      profileImages.add(PartyImageWithstatus(image: profileC.value, status: photoStatusApproval_c.value));
    }
    if( profileD.value!=''  ){
      //profileImages.add(profileD.value);
      profileImages.add(PartyImageWithstatus(image: profileD.value, status: photoStatusApproval_d.value));
    }
    if(profileE.value !='' ){
      //profileImages.add(profileE.value);
      profileImages.add(PartyImageWithstatus(image: profileE.value, status: photoStatusApproval_e.value));
    }
    profileImages.forEach((element) {
      print(element.toString());
    });
  }

  Future<void> getAllCities() async {
    try {
      final response = await http.get(
        Uri.parse(API.individualCities),
        headers: {
          'x-access-token': '${GetStorage().read('token')}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> cityListJson =
        json.decode(response.body)['data'] as List;
        allCityList.value =
            cityListJson.map((city) => IndividualCity.fromJson(city)).toList();
            activeCities.add('Select Active city');
        allCityList.forEach((element) {
          activeCities.add(element.name);
        });
        log("cities $cityListJson");
        update();
      } else {
        throw Exception("Error with the request: ${response.statusCode}");
      }
    } on SocketException {
      log('Socket Exception No Internet connection Please check your internet connection and try again.');
    } on HttpException {
      log('HttpException Something went wrong Couldn\'t find the post.');
    } on FormatException {
      log('Format Exception Something went wrong Bad response format');
    }
  }

  void showSelectPhotoOptionsProfileImages(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickAllImageProfile,
              ),
            );
          }),
    );
  }

  _pickAllImageProfile(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source, imageQuality: 50);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      if (profilePhotoSelectNo == 1) {
        imageProfile_b = img!;
        String url = await apiService.uploadImage(type: '1',
            imgFile: imageProfile_b,
            id: organization_id.value,
            imageKey: 'profile_pic_b');
        if (url.isNotEmpty) {
          profileB.value = url;
        }
      }
      if (profilePhotoSelectNo == 2) {
        imageProfile_c = img!;

        String url = await apiService.uploadImage(type: '1',
            imgFile: imageProfile_c,
            id: organization_id.value,
            imageKey: 'profile_pic_c');
        if (url.isNotEmpty) {
          profileC.value = url;
        }
      }
      if (profilePhotoSelectNo == 3) {
        imageProfile_d = img!;

        String url = await apiService.uploadImage(type: '1',
            imgFile: imageProfile_d,
            id: organization_id.value,
            imageKey: 'profile_pic_d');
        if (url.isNotEmpty) {
          profileD.value = url;
        }
      }
      if (profilePhotoSelectNo == 4) {
        imageProfile_e = img!;

        String url = await apiService.uploadImage(type: '1',
            imgFile: imageProfile_e,
            id: organization_id.value,
            imageKey: 'profile_pic_e');
        if (url.isNotEmpty) {
          profileE.value = url;
        }
      }
      /* isLoading.value = true;
      savePhotoToFirebase('${GetStorage().read('token')}', img!, 'profileImage')
          .then((value) {
        profile.value = value!;
      });*/

      Get.back();
    }
    on PlatformException {
      Get.back();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    var croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  void onClose() {
    activeCities.clear();
    //activeCity="".obs;
    super.onClose();
  }
}

class PartyImageWithstatus {
  String image;
  String status;
  PartyImageWithstatus({required this.image,required this.status});
}
