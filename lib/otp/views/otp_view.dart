import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/login/controller/login_controller.dart';
import 'package:partypeopleindividual/otp/controller/otp_controller.dart';
import 'package:partypeopleindividual/widgets/custom_button.dart';

class OTPScreen extends StatefulWidget {
  final String enteredNumber;

  OTPScreen({super.key, required this.enteredNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  String otpCodeValue = '';

  APIService apiService = Get.find();

  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;

  OTPController otpController = Get.put(OTPController());

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
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
                    child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        )),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        )),
                  ),
                  Positioned(
                    child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Enter the 4-digit code sent to you \nat ',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                    TextSpan(
                                      text: "+91" + widget.enteredNumber,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text:
                                          ' did you enter the \ncorrect number?',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.left,
                              )),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: OTPTextField(
                        controller: OtpFieldController(),
                        keyboardType: TextInputType.number,
                        isDense: false,
                        margin: const EdgeInsets.all(8),
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 55,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        contentPadding: const EdgeInsets.all(20),
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: Colors.grey.shade100,
                          focusBorderColor: Colors.black,
                          enabledBorderColor: Colors.black,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (pin) {
                          otpController.otp.value = pin;
                        },
                        onCompleted: (pin) {
                          otpController.otp.value = pin;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        loginController.login();
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Don\'t receive the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            const TextSpan(
                              text: 'OTP',
                              style: TextStyle(color: Colors.black),
                            ),
                            const TextSpan(
                              text: ' ?',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: ' RESEND OTP',
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                          ],
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    apiService.isLoading.value == true
                        ? const CupertinoActivityIndicator(
                            color: Colors.grey,
                            radius: 10,
                          ) // Show loading indicator while API call is in progress
                        : Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.red.shade900,
                            child: CustomButton(
                              width: Get.width * 0.6,
                              text: 'VERIFY OTP',
                              onPressed: otpController.otpVerify,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
