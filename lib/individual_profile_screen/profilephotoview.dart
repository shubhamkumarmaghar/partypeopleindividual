import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePhotoView extends StatelessWidget {
   final String profileUrl;
   final String approvalStatus;
   ProfilePhotoView({super.key,required this.profileUrl,required this.approvalStatus});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Blur(blur:9 ,
          child:
          Container(width: Get.width,
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
            imageUrl: profileUrl,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          ),
          overlay: approvalStatus != '1'
          ? Container():
          Container(width: Get.width,
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
            imageUrl: profileUrl,
            width: Get.width,
            fit: BoxFit.cover,
          ),
        ),
      ) ,
    ));
  }
}
