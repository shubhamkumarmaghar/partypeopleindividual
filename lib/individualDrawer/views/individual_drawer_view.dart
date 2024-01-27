import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/edit_individual_profile/edit_individual_profile.dart';
import 'package:partypeopleindividual/individual_blocked_report/view/blocked_report_screen.dart';
import 'package:partypeopleindividual/individual_subscription/view/subscription_view.dart';
import 'package:partypeopleindividual/login/views/login_screen.dart';
import 'package:partypeopleindividual/visitInfo/views/visit_info_view.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../individual_book_party_report/view/book_party_list_screen.dart';
import '../../individual_transction_report/view/transction_screen.dart';
import '../../settings/view/settings.dart';
import '../../widgets/block_unblock.dart';
import '../../widgets/payment_response_view.dart';

class IndividualDrawerView extends StatefulWidget {
  IndividualDrawerView({
    Key? key,
  });

  @override
  State<IndividualDrawerView> createState() => _IndividualDrawerViewState();
}

class _IndividualDrawerViewState extends State<IndividualDrawerView> {
  String approvalStauts = GetStorage().read('approval_status') ?? '0';

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  /*     colors: [
                 //   Colors.pink,
                   // Colors.red.shade900
                    Colors.red.shade800,
                    Color(0xff7e160a),
                    Color(0xff2e0303),
                  ],*/

                  colors: [Colors.pink, Colors.red.shade900],
                  // begin: Alignment.topCenter,
                  //  end: Alignment.bottomCenter,
                ),
              ),
            ),
            leading: BackButton(
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.red.shade900,
            elevation: 0,
            title: Text(
              "My Profile",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(children: [
/*
                  CustomOptionWidget(
                    title: 'Edit Profile',
                    icon: Icons.edit,
                    onTap: () => Get.to(
                        PaymentResponseView(amount: '10',isSuccess: '1',orderId: '5jvjfbjbjfkn',)),
                  ),*/
                  CustomOptionWidget(
                    title: 'Edit Profile',
                    icon: Icons.edit,
                    onTap: () => Get.to(EditIndividualProfile()),
                  ),
                  CustomOptionWidget(
                    title: 'Likes and Views',
                    icon: Icons.view_agenda,
                    onTap: () {
                      if (approvalStauts == '1') {
                        Get.to(VisitInfoView());
                      } else {
                        Get.snackbar('Sorry!', 'Your account is not approved , please wait until it got approved');
                      }
                    },
                  ),
              /*    CustomOptionWidget(
                    title: 'Subscription Plan',
                    icon: CupertinoIcons.list_bullet_below_rectangle,
                    onTap: () {
                      Get.to(SubscriptionView(subText: 'Get complete access of Application',iconText: 'https://assets-v2.lottiefiles.com/a/dade640a-118b-11ee-bbfd-2b667fe34e14/wdWPPO8OuG.json',));
                    },
                  ),*/
                  CustomOptionWidget(
                    title: 'Blocked/Reported',
                    icon: Icons.block,
                    onTap: () {
                      Get.to(BlockedReportedUsersView());
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Transaction History',
                    icon: CupertinoIcons.list_bullet_below_rectangle,
                    onTap: () {
                      Get.to(TransctionReportedUsersView());
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Party Booking History',
                    icon: CupertinoIcons.list_bullet_below_rectangle,
                    onTap: () {
                      Get.to(BookPartyListView());
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      Get.to(
                        Settings(),
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.leftToRight,
                      );
                    },
                  ),
                  /*   CustomOptionWidget(
                    title: 'Frequently Asked Questions',
                    icon: Icons.question_answer,
                    onTap: () {
                      _launchURL('http://partypeople.in');
                    },
                  ),*/
                  CustomOptionWidget(
                    title: 'Need Any Help?',
                    icon: Icons.help_center,
                    onTap: () {
                      _launchURL('https://partypeople.in/#contact');
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () async {
                      final Uri _url = Uri.parse("https://partypeople.in/privacy_policy_individual_app");

                      if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                      }
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Logout',
                    icon: Icons.exit_to_app,
                    onTap: () {
                      Alertdialogs.showLogoutAlertDialog(context);
                    },
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}

class CustomOptionWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  CustomOptionWidget({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.red.shade400,
                  /*  Colors.red.shade800,
                  Color(0xff7e160a),
                  Color(0xff2e0303),*/

                  Colors.pink,
                  Colors.red.shade900
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24.0,
                  color: Colors.white,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
