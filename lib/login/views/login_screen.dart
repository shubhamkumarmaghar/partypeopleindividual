import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/login/controller/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  APIService apiService = Get.put(APIService());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  LoginController loginController = Get.put(LoginController());

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
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Obx(
                () => Column(
                  children: <Widget>[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: <Widget>[
                          CustomTextField(
                            validate: true,
                            hintText: 'Username',
                           maxLength: 10,
                            maxLines: 1,
                            obscureText: false,
                            icon: Icons.person,
                            onChanged: (value) {
                              setState(() {
                                loginController.username.value = value;
                              });
                            },
                          ),
                          CustomTextField(
                            validate: true,
                            maxLength: 10,
                            hintText: 'Mobile Number',
                            obscureText: false,
                            icon: Icons.phone,
                            textInput: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                loginController.mobileNumber.value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red.shade900,
                            value: loginController.isChecked.value,
                            onChanged: (value) {
                              setState(() {
                                loginController.isChecked.value =
                                    value ?? false;
                              });
                            },
                          ),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: InkWell(
                              onTap: () async {
                                const url =
                                    'https://partypeople.in'; // URL to redirect to
                                // ignore: deprecated_member_use
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    apiService.isLoading.value == true
                        ? const CupertinoActivityIndicator(
                            color: Colors.grey,
                            radius: 10,
                          ) // Show loading indicator while API call is in progress
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.red.shade900,
                              child: CustomButton(
                                width: Get.width * 0.6,
                                text: 'LOGIN',
                                onPressed: loginController.login,
                              ),
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
