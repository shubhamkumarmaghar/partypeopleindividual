import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:partypeopleindividual/onboarding-screens/color_const.dart';
import 'package:partypeopleindividual/onboarding-screens/onboardingmodel.dart';
import 'package:partypeopleindividual/onboarding-screens/string_constants.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnBoardingPages(
        model: OnBoardingModel(
          image: tOnBoardingImage1,
          title: tOnBoardingSubTitle1,
          subTitle: tOnBoardingSubTitle1,
          counterText: tOnBoardingCounter1,
          size: MediaQuery.of(context).size,
          bgColor: tOnBoardingPage1Color,
        ),
      ),
      OnBoardingPages(
        model: OnBoardingModel(
          image: tOnBoardingImage2,
          title: tOnBoardingSubTitle2,
          subTitle: tOnBoardingSubTitle2,
          counterText: tOnBoardingCounter2,
          size: MediaQuery.of(context).size,
          bgColor: tOnBoardingPage2Color,
        ),
      ),
      OnBoardingPages(
        model: OnBoardingModel(
          image: tOnBoardingImage3,
          title: tOnBoardingSubTitle3,
          subTitle: tOnBoardingSubTitle3,
          counterText: tOnBoardingCounter3,
          size: MediaQuery.of(context).size,
          bgColor: tOnBoardingPage3Color,
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [LiquidSwipe(pages: pages)],
      ),
    );
  }
}

class OnBoardingPages extends StatelessWidget {
  const OnBoardingPages({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: model.bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(model.image),
              height: model.size.height * 0.5,
            ),
            Column(
              children: [
                Text(
                  tOnBoardingSubTitle1,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Text(
                  tOnBoardingSubTitle1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            Text(
              tOnBoardingCounter1,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
