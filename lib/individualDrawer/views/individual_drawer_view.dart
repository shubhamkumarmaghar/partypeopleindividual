import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/edit_individual_profile/edit_individual_profile.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualDrawerView extends StatefulWidget {
  IndividualDrawerView({
    Key? key,
  });

  @override
  State<IndividualDrawerView> createState() => _IndividualDrawerViewState();
}

class _IndividualDrawerViewState extends State<IndividualDrawerView> {
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
          appBar: AppBar(
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
                  CustomOptionWidget(
                    title: 'Edit Profile',
                    icon: Icons.edit,
                    onTap: () => Get.to(EditIndividualProfile()),
                  ),
                  CustomOptionWidget(
                    title: 'Frequently Asked Questions',
                    icon: Icons.question_answer,
                    onTap: () {
                      _launchURL('http://partypeople.in');
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Need Any Help?',
                    icon: Icons.help_center,
                    onTap: () {
                      _launchURL('https://partypeople.in/#contact');
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Party History',
                    icon: Icons.history,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Blocked/Reported',
                    icon: Icons.block,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Likes and Views',
                    icon: Icons.view_agenda,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Reminder',
                    icon: Icons.alarm,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Party Planner Toolkit',
                    icon: Icons.stay_primary_portrait,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Feedback and ratings',
                    icon: Icons.feedback,
                    onTap: () {
                      _launchURL('https://partypeople.in/');
                    },
                  ),
                  CustomOptionWidget(
                    title: 'Previous guests List',
                    icon: Icons.list,
                    onTap: () {},
                  ),
                  CustomOptionWidget(
                    title: 'Contact information',
                    icon: Icons.contact_page,
                    onTap: () {
                      _launchURL('https://partypeople.in/');
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade800,
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
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins'),
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
