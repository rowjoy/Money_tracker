import 'package:flutter/material.dart';
import 'package:moneytracker/views/onboard/pageview.dart';

class OnboardPageView extends StatelessWidget {
  OnboardPageView({super.key});

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Pageviewbody(
        controller: pageController,
      ).build(context),
    );
  }
}