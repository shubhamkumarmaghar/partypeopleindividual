import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';
import 'package:partypeopleindividual/widgets/custom_button.dart';
import 'package:partypeopleindividual/widgets/custom_country_state_city.dart';
import 'package:partypeopleindividual/widgets/custom_loading_indicator.dart';
import 'package:partypeopleindividual/widgets/custom_textfield.dart';
import 'package:partypeopleindividual/widgets/individual_amenities.dart';
import 'package:partypeopleindividual/widgets/occupation_dropdown_selector.dart';
import 'package:partypeopleindividual/widgets/qualification_dropdown_widget.dart';
import 'package:blur/blur.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/dob_dropdown.dart';
import '../../widgets/gender_dropdown_selecter.dart';
import '../centralize_api.dart';
import '../widgets/active_city_select.dart';
import '../widgets/custom_textview_profile.dart';
import 'add_profile_images.dart';

class EditIndividualProfile extends StatefulWidget {
  const EditIndividualProfile({super.key});

  @override
  State<EditIndividualProfile> createState() => _EditIndividualProfileState();
}

class _EditIndividualProfileState extends State<EditIndividualProfile> {
  //File? _coverImage;
  //File? _profileImage;
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
    individualProfileController.getAllCities();
    _fetchData();
  }

  @override
  void initState() {
    futureInit();
    super.initState();
  }

  @override
  void dispose() {
    individualProfileController.activeCities.clear();
    individualProfileController.activeCity = "".obs;
    super.dispose();
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
                                GestureDetector(
                                  onTap: () => _updatePhoto('cover'),
                                  child: individualProfileController
                                              .photoStatusApproval.value !=
                                          '1'
                                      ? Blur(
                                          blur: 5.0,
                                          child: Container(
                                            height: 300,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: individualProfileController.coverImage.path.isNotEmpty && individualProfileController.coverImage.path !=''
                                                      ? FileImage(individualProfileController.coverImage)
                                                      : individualProfileController
                                                              .coverPhotoURL
                                                              .value
                                                              .isNotEmpty
                                                          ? NetworkImage(
                                                              individualProfileController
                                                                  .coverPhotoURL
                                                                  .value)
                                                          : const AssetImage(
                                                                  'assets/images/default-cover-4.jpg')
                                                              as ImageProvider<
                                                                  Object>),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: individualProfileController.coverImage.path.isNotEmpty && individualProfileController.coverImage.path != ''
                                                    ? FileImage(individualProfileController.coverImage)
                                                        as ImageProvider<Object>
                                                    : individualProfileController
                                                            .coverPhotoURL
                                                            .value
                                                            .isNotEmpty
                                                        ? NetworkImage(
                                                                individualProfileController
                                                                    .coverPhotoURL
                                                                    .value)
                                                            as ImageProvider<
                                                                Object>
                                                        : const AssetImage(
                                                                'assets/images/default-cover-4.jpg')
                                                            as ImageProvider<
                                                                Object>),
                                          ),
                                        ),
                                ),

                                // Profile Photo
                                Positioned(
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () => _updatePhoto('profile'),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                       boxShadow: [
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.transparent,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                      individualProfileController
                                          .photoStatusApproval.value !=
                                          '1' ?
                                      Blur(
                                              blur: individualProfileController
                                                  .photoStatusApproval.value !=
                                                  '1' ?5:0,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                radius: 55,
                                                backgroundImage: individualProfileController.profileImage.path.isEmpty
                                                    ? FileImage(individualProfileController.profileImage!)
                                                    : (individualProfileController
                                                                .profilePhotoURL
                                                                .value
                                                                .isNotEmpty
                                                            ? NetworkImage(
                                                                individualProfileController
                                                                    .profilePhotoURL
                                                                    .value)
                                                            : const AssetImage(
                                                                'assets/images/man.png'))
                                                        as ImageProvider<
                                                            Object>?,
                                              ),
                                            ): CircleAvatar(
                                        radius: 55,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:individualProfileController.profileImage.path.isEmpty
                                            ? FileImage(individualProfileController.profileImage!)
                                            : (individualProfileController
                                            .profilePhotoURL
                                            .value
                                            .isNotEmpty
                                            ? NetworkImage(
                                            individualProfileController
                                                .profilePhotoURL
                                                .value)
                                            : const AssetImage(
                                            'assets/images/man.png'))
                                        as ImageProvider<Object>?,
                                      ) ,

                                    ),
                                  ),
                                ),
                                // Edit Button for Profile Photo
                                Positioned(
                                  bottom: 10,
                                  right: Get.width * .39,
                                  child: GestureDetector(
                                    onTap: () => _updatePhoto('profile'),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () => _updatePhoto('cover'),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                       color:  Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
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
                                ),

                                Positioned(
                                top: Get.height*0.05,
                                  left: Get.height*0.02,
                                  child:
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
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
                                ),
                              ],
                            ),

                            ///Other Individual Widget
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                Get.to( AddImageProfile());
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: Get.width*0.25,
                                  margin: EdgeInsets.only(right: 28),
                                  alignment: Alignment.center,
                                  height: Get.width*0.08,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange),
                                  child: Text('Add Images',
                                    style: TextStyle(fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                        validate: true,
                                        hintText: 'First Name',
                                        obscureText: false,
                                        initialValue:
                                            individualProfileController
                                                .firstname.value.capitalizeFirst,
                                        onChanged: (value) {
                                          individualProfileController
                                              .firstname.value = value.capitalizeFirst!;
                                        },
                                        icon: Icons.person)),
                                Expanded(
                                    child: CustomTextField(
                                        validate: true,
                                        hintText: 'Last Name',
                                        obscureText: false,
                                        initialValue:
                                            individualProfileController
                                                .lastname.value.capitalizeFirst,
                                        onChanged: (value) {
                                          individualProfileController
                                              .lastname.value = value.capitalizeFirst!;
                                        },
                                        icon: Icons.person)),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                        validate: true,
                                        hintText: 'E-Mail',
                                        obscureText: false,
                                        initialValue:
                                        individualProfileController
                                            .email.value,
                                        onChanged: (value) {
                                          individualProfileController
                                              .email.value = value;
                                        },
                                        icon: Icons.email)),
                              ],
                            ),
                            individualProfileController
                                        .descStatusApproval.value ==
                                    '0'
                                ? Blur(
                                    blur: 2.5,
                                    child: CustomTextField(
                                        validate: true,
                                        hintText: 'Bio',
                                        obscureText: false,
                                        initialValue:
                                            individualProfileController
                                                .description.value,
                                        icon: Icons.description,
                                        iconColor: Colors.red.shade900,
                                        onChanged: (value) {
                                          individualProfileController
                                              .description.value = value;
                                        },
                                        maxLines: 3),
                                  )
                                : CustomTextField(
                                    validate: true,
                                    hintText: 'Bio',
                                    obscureText: false,
                                    initialValue: individualProfileController
                                        .description.value,
                                    icon: Icons.description,
                                    textInput: TextInputType.multiline,
                                    onChanged: (value) {
                                      log('abcs ${value}');
                                      individualProfileController
                                          .description.value = value;
                                    },
                                    maxLines: 3),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomDateField(
                                    validate: true,
                                    hintText: 'Date of Birth',
                                    icon: Icons.calendar_today,
                                    controller: individualProfileController
                                        .dobController,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.snackbar('Sorry',
                                            'You Can not change gender');
                                      },
                                      child: CustomProfileTextView(
                                        text: individualProfileController
                                            .gender.value,
                                        icon: Icons.people_outline,

                                      )),
                                  //GenderSelect(),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Expanded(
                                  child: QualificationWidget(),
                                ),
                                Expanded(
                                  child: OccupationWidget(),
                                ),
                              ],
                            ),

                            SelectState(
                                onCountryChanged: (onCountryChanged) {},
                                onStateChanged: (onCountryChanged) {},
                                onCityChanged: (onCityChanged) {}),

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
                                  child: ActiveCitySelect(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

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
                                                        onTap: () =>
                                                            _selectAmenity(
                                                                amenity),
                                                        child: Chip(
                                                          avatar: CircleAvatar(
                                                            backgroundColor:
                                                                amenity.selected
                                                                    ? Colors.red[
                                                                        700]
                                                                    : Colors.grey[
                                                                        700],
                                                          ),
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
                                                              amenity.selected
                                                                  ? Colors.red.shade900
                                                                  : Colors.grey[
                                                                      400],
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
                            apiService.isLoading.value == true
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

  Future<void> _updatePhoto(String type) async {
    try {
      ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) => Container(
          color: const Color(0xFF737373),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.camera,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.photo_album,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      );
      if (source != null) {
        final pickedFile = await _picker.pickImage(source: source ,imageQuality:  50);
        if (pickedFile == null) {
          throw Exception('No image file was picked.');
        }

        File? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        );

        if (croppedFile == null) {
          throw Exception('Image cropping failed or was cancelled.');
        }

      /*  setState(() {
          _isLoading = true;
        });
*/
        try {
         // String downloadUrl = await individualProfileController.apiService.uploadImage(type: '1', id: individualProfileController.organization_id.value, imageKey: 'cover_photo',imgFile: croppedFile);
          //await _uploadFile(croppedFile, type);

            if (type == 'cover') {
              individualProfileController.coverImage = croppedFile;
              String downloadUrl = await individualProfileController.apiService.uploadImage(type: '1', id: individualProfileController.organization_id.value, imageKey: 'cover_photo',imgFile: croppedFile);
              individualProfileController.coverPhotoURL.value = downloadUrl;
            } else {
              individualProfileController.profileImage = croppedFile;
              String downloadUrl = await individualProfileController.apiService.uploadImage(type: '1', id: individualProfileController.organization_id.value, imageKey: 'profile_photo',imgFile: croppedFile);
              individualProfileController.profilePhotoURL.value = downloadUrl;
            }
            // _isLoading = false;
        } on FirebaseException catch (e) {
          // Handle Firebase specific exceptions
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on PlatformException catch (e) {
      // Handle exceptions related to camera, files and permissions
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _uploadFile(File file, String filename) async {
    try {
      UploadTask task = FirebaseStorage.instance
          .ref('individual/token/${GetStorage().read('token')}/$filename')
          .putFile(file);

      task.snapshotEvents.listen((TaskSnapshot event) {
        double progress = event.bytesTransferred / event.totalBytes;
        setState(() {
          _progress = progress;
        });
      });

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        final String downloadURL = await snapshot.ref.getDownloadURL();
        return downloadURL;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
