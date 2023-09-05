import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/individualDashboard/views/individual_dashboard_view.dart';
class ShowSubmitMessage extends StatefulWidget {
  const ShowSubmitMessage({Key? key}) : super(key: key);

  @override
  State<ShowSubmitMessage> createState() => _ShowSubmitMessageState();
}

class _ShowSubmitMessageState extends State<ShowSubmitMessage> {

  late Timer timer;
  @override
  void initState() {
     timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      Get.offAll(const IndividualDashboardView());


    });

    super.initState();
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5a0404),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/success.png',
              height: 400,
              width: 300,
            ),
            const Text(
              "Application Submitted Successfully",
              style: TextStyle(
                fontSize: 34,
                color: Color(0xff09D6AB),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "We have received your application. It will be approved within 24 hours.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "If not approved, Please contact us",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
