import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomProfileTextView extends StatelessWidget {
  String text;IconData icon;  Color color;
  CustomProfileTextView({required this.text , required this.icon ,  this.color =const Color(0xFFB71C1C)});

  @override
  Widget build(BuildContext context) {
    return  Neumorphic(
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
          children: [
            Icon(icon, color: color),
            SizedBox(
              width: Get.width * 0.03,
            ),
            Container(
              width: Get.width*.28,
              height: Get.height*0.02,
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: NeumorphicText(text,
                    style: NeumorphicStyle(
                      color: Colors.black,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 14,
                    )),
              ),
            ),
          ],
        ));
  }
}
