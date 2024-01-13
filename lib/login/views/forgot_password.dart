import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../controller/login_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [

          Container(
            height: Get.height * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/light-1.png'))),
                  ),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/light-2.png'))),
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 40,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'))),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const Center(
                      child: Text(
                        "Forgot UserName",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height*0.05,),
          CustomTextField(
            validate: true,
           // maxLength: 10,
            hintText: 'Mobile Number or Email',
            obscureText: false,
            icon: Icons.format_align_center,
            textInput: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                loginController.forgotMobileNumber.value = value;
              });
            },
          ),
          Container(margin:  const EdgeInsets.only(left: 12.0),
            alignment:Alignment.centerLeft,
            child: Text('*You will receive OTP on this Number/Email' ,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),),
          ),
          const SizedBox(height: 20),
          loginController.apiService.isLoading.value == true
              ? const CupertinoActivityIndicator(
            color: Colors.grey,
            radius: 10,
          ) // Show loading indicator while API call is in progress
              : Center(
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.red.shade900,
              child: CustomButton(
                width: Get.width * 0.6,
                text: 'Submit',
                onPressed: loginController.forgotPassword,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
