import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfilePhotoView extends StatelessWidget {
   final String profileUrl;
   ProfilePhotoView({super.key,required this.profileUrl});

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
        child: Container(width: Get.width,
        child: Image.network(profileUrl),),
      ) ,
    );
  }
}
