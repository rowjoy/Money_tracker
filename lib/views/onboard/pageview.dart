// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/bloc/onboard_bloc/onboard_bloc.dart';
import 'package:moneytracker/route/app_route.dart';
import 'package:moneytracker/route/page_path.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:moneytracker/views/onboard/data_source.dart';
import 'package:moneytracker/widget/app_button.dart';

class Pageviewbody {
  final PageController controller;


  Pageviewbody({required this.controller});

  Widget build (BuildContext context){
    return BlocBuilder<OnboardCubit , int>(
      builder: (context, currentPage) {
        final lastPageIndex = DataSource.rowData.length - 1;
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                 controller: controller,
                 onPageChanged: (value){
                   context.read<OnboardCubit>().onPageChanged(value);
                 },
                 itemCount: DataSource.rowData.length,
                 itemBuilder: (context, index){
                   return ReUsebody(
                      images: DataSource.rowData[index].images, 
                      title: DataSource.rowData[index].title, 
                      dotActiveIndex: index,
                    );
                  }
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                onTap: (){
                    if (currentPage < lastPageIndex) {
                      // small animated page change
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      // No need to manually emit here — onPageChanged will fire
                    } else {
                      context.pushReplacement(PagePath.dashBordView);
                      // last page → do something (e.g. navigate to home)
                      // Navigator.pushReplacement(...);
                      print("Done");
                    }
                }, 
                title:  currentPage == lastPageIndex ? "GET STARTED" : "NEXT"
              ),
            ),
            SizedBox(height: 5),
          ],
        );
      }
    );
  }
}

class OnBoardButton extends StatelessWidget {
  final Function() onTap;
  final String buttonTitle;

  const OnBoardButton({
    required this.onTap,
    required this.buttonTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
            // color: Colors.black,
            gradient: LinearGradient(colors: ListColorCode.colorset1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(buttonTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReUsebody extends StatelessWidget {
  final String title;
  final String images;
  final int dotActiveIndex;

  const ReUsebody({
    super.key,
    required this.images,
    required this.title,
    required this.dotActiveIndex,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             ImagePart(images: images, activeIndex: dotActiveIndex,),
             SizedBox(height: 35,),
             Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 10,left: 40,right: 40),
                   child: Text(title,
                   textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                   
                     ),
                   ),
                 ),
                 SizedBox(height: 50,),
               ],
             ),
           ],
        ),
      ),
    );
  }
}

class ImagePart extends StatelessWidget {
  final String images;
  final int activeIndex;
  const ImagePart({
    super.key,
    required this.images,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(images),
        SizedBox(height: 100,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index)=> Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width:  index == activeIndex  ? 50 : 30,
              height: 6,
              decoration: BoxDecoration(
                // index == activeIndex  color:  index == activeIndex  ? ProjectColor.blueAccent : ProjectColor.grey,
                gradient: LinearGradient(colors:index == activeIndex ? ListColorCode.colorset1 : [ProjectColor.grey,  ProjectColor.whiteColor]),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
           ),
          ),
        ),
      ],
    );
  }
}