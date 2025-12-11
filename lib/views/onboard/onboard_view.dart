import 'package:flutter/material.dart';
import 'package:moneytracker/views/onboard/pageview.dart';

class OnboardPageView extends StatelessWidget {
  const OnboardPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Pageviewbody().build(context),
    );
  }
}