import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/login/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offAll(const LoginScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/splashscreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
