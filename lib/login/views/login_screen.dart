import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/api_helper_service.dart';
import 'package:partypeopleindividual/login/controller/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'forgot_password.dart';

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
              height: Get.height*0.4,
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
                          margin: const EdgeInsets.only(top: 40),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: -Get.width*0.3,
                    width: Get.width,
                    height: 150,
                    child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          child:   Text('Please Choose Country ',style: TextStyle(fontSize: 18,color: Colors.grey.shade900),),
                        )
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0,right: 30,),
              child: Obx(
                () => Column(
                  children: <Widget>[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  loginController.countryType ='1';
                                  setState(() {
                                  });
                                  //Get.to(LoginView(countryType: '1',));
                                },
                                child:
                                Container(
                                    width: Get.width*0.4,
                                    height: Get.width*0.2,
                                   // margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child:Card(
                                      shape:RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      color:  loginController.countryType =='1'? Colors.green.shade600:Colors.white,
                                      child: Row( children: [
                                        SizedBox(width: 10),
                                        CircleAvatar(backgroundImage: AssetImage('assets/images/indian_flag.png',) ,radius: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Container(width:Get.width*0.15,
                                            child: Text('India',style: TextStyle(fontSize: 20,color: loginController.countryType =='1'? Colors.white:Colors.grey.shade900),)),
                                      ]
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(height: Get.width*0.2,),
                              GestureDetector(
                                onTap: (){
                                  loginController.countryType = '2';

                                  setState(() {

                                  });
                                  // Get.to(LoginView(countryType: '1',));
                                },
                                child:
                                Container(
                                    width: Get.width*0.4,
                                    height: Get.width*0.2,
                                   // margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child:Card(color: loginController.countryType =='2'? Colors.green.shade600:Colors.white,
                                      shape:RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      child: Row( children: [
                                        SizedBox(width: 10),
                                        //   CircleAvatar(backgroundImage: AssetImage('assets/other_world.png',) ,radius: 20,),
                                        Icon(CupertinoIcons.globe,size: 38,color: loginController.countryType =='2'? Colors.white:Colors.grey.shade700,),
                                        SizedBox(width: 10),
                                        Container(width:Get.width*0.15,
                                            child: Text('World ',style: TextStyle(fontSize: 20,color: loginController.countryType =='2'? Colors.white:Colors.grey.shade900),)),
                                      ]
                                      ),
                                    )
                                ),
                              ),

                            ],),
                        //  SizedBox(height: Get.height*0.05,),
                          Container(margin:  const EdgeInsets.only(left: 12.0,bottom: 12.0),
                              alignment: Alignment.centerLeft,child: Text('LogIn or SignUp',
                                style: TextStyle(color: Colors.grey.shade600,fontSize: 18),)),
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
                         loginController.countryType=='1' ?CustomTextField(
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
                          ):
                          CustomTextField(
                            validate: true,
                            //maxLength: 10,
                            hintText: 'Email',
                            obscureText: false,
                            icon: Icons.mail,
                            textInput: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                loginController.email.value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Container(margin:  const EdgeInsets.only(left: 12.0),
                      alignment:Alignment.centerLeft,
                      child: Text('*You will receive OTP on this ${loginController.countryType=='1' ? 'Number':'Email' } ',
                      style: TextStyle(
                      color: Colors.grey,
                        fontSize: 12
                    ),),),
                    GestureDetector(
                      onTap: (){
                        Get.to(ForgotPassword());
                      },
                      child: Container(margin:  const EdgeInsets.only(left: 12.0),
                        alignment:Alignment.centerRight,
                        child: Text('Forgot Username ? ',
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.w600,
                              fontSize: 14
                          ),),),
                    ),
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
                        : Center(
                          child: FadeTransition(
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
