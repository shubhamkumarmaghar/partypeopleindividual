import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../individual_profile/controller/individual_profile_controller.dart';
import '../widgets/cached_image_placeholder.dart';


class AddImageProfile extends StatefulWidget {
  const AddImageProfile({super.key});

  @override
  State<AddImageProfile> createState() => _AddImageProfileState();
}

class _AddImageProfileState extends State<AddImageProfile> {
  IndividualProfileController controller = Get.find();
 // DefaultController defaultController = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.white,
      body:
    Container(margin: EdgeInsets.all(10),child:
    Column(
      children: [
        SizedBox(
          height: Get.height*0.05,
        ),
        Row(
          children: [
            GestureDetector(onTap: (){Navigator.pop(context);},
              child: Container(alignment: Alignment.bottomLeft,
                  child: CircleAvatar(child: Icon(Icons.arrow_back,color: Colors.red.shade900,),
                    backgroundColor: Colors.red.shade50,)),
            ),
            const SizedBox(
              width: 20,
            ),
            Text('Add more Images',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.black),),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
       GestureDetector(
         onTap: () {
          // defaultController.defaultControllerType.value = 0;
           controller.profilePhotoSelectNo.value=1;
           controller.showSelectPhotoOptionsProfileImages(context);
         },
         child: Obx(
                 () =>
       customAddImage(imageFile: controller.imageProfile_b, imageUrl: controller.profileB.value)
    ),),
       GestureDetector(
         onTap: () {
          // defaultController.defaultControllerType.value = 0;
           controller.profilePhotoSelectNo.value=2;
           controller.showSelectPhotoOptionsProfileImages(context);
         },
         child: Obx(
                 () =>
                 customAddImage(imageFile: controller.imageProfile_c, imageUrl: controller.profileC.value)
         ),),
     ],),
        SizedBox(height: 20,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          GestureDetector(
            onTap: () {
              //defaultController.defaultControllerType.value = 0;
              controller.profilePhotoSelectNo.value=3;
              controller.showSelectPhotoOptionsProfileImages(context);
            },
            child: Obx(
                    () =>
                    customAddImage(imageFile: controller.imageProfile_d, imageUrl: controller.profileD.value)
            ),),
          GestureDetector(
            onTap: () {
              //defaultController.defaultControllerType.value = 0;
              controller.profilePhotoSelectNo.value=4;
              controller.showSelectPhotoOptionsProfileImages(context);
            },
            child: Obx(
                    () =>
                    customAddImage(imageFile: controller.imageProfile_e, imageUrl: controller.profileE.value)
            ),),
        ],),
        SizedBox(height: 20,),
      /*  GestureDetector(
          onTap: (){
            Fluttertoast.showToast(msg: 'Your images have successfully uploaded ');
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: Get.width*0.35,
              margin: EdgeInsets.only(right: 28),
              alignment: Alignment.center,
              height: Get.width*0.08,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: Colors.orange),
              child: FittedBox(
                child: Text('Upload',
                  style: TextStyle(fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),),
              ),
            ),
          ),
        ),*/
    ],
    ),
    ),
    );
  }

  customAddImage({required File imageFile ,required String imageUrl }){
    return Stack(
      children: [
       // controller.isLoading.value == false
            //?
    Container(
          height: Get.height*0.25,
          width: Get.height*0.21,
          child: imageUrl.isNotEmpty && imageFile.path.isEmpty
              ? Card(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImageWidget(
                  imageUrl: imageUrl,
                  width: Get.height*0.12,
                  height: Get.height*0.12,
                  fit: BoxFit.fill,
                  errorWidget: (context, url,
                      error) =>
                   Center(
                    child:  Card(
                       color: Colors.red.shade50,
                      child: Lottie.asset(
                        'assets/images/127619-photo-click.json',
                      ),
                   /* CupertinoActivityIndicator(
                      radius: 15,
                      color: Colors.black,
                    ),*/
                  ),),
                  placeholder: (context, url) =>
                  const Center(
                      child:
                      CupertinoActivityIndicator(
                          color: Colors
                              .black,
                          radius: 15))
              ),
          )
              : imageFile.path.isEmpty ?
          Card(
            child: Lottie.asset(
              'assets/images/127619-photo-click.json',
            ),
          ):Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
              ),clipBehavior: Clip.hardEdge,
              child: Image.file(imageFile,fit: BoxFit.fill,)
          ),
        )
      /*  Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            child: IconButton(
              onPressed: () {
                defaultController
                    .defaultControllerType.value = 2;
                // _showSelectPhotoOptionsProfile(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),*/
      ],
    );
  }
}
