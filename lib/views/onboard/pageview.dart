// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytracker/views/onboard/data_source.dart';

class Pageviewbody {
 

  Widget build (BuildContext context){
    return PageView.builder(
       onPageChanged: (value) {
          print(value);
       },
       itemCount: DataSource.rowData.length,
       itemBuilder: (context, index){
         return ReUsebody(
            images: DataSource.rowData[index].images, 
            title: DataSource.rowData[index].title, 
            buttonTitle: DataSource.rowData[index].buttonTitle,
            onTap: (){
               print("ReUsebody : ${ReUsebody}");
            }
          );
       }
      );
    // return PageView(
    //    physics: ScrollPhysics(parent:ScrollPhysics()),
    //    scrollDirection: Axis.horizontal,
    //    children: [
    //        // ignore: sized_box_for_whitespace
    //        //SvgImagesPath.onboardImagetwo
    //        ReUsebody(
    //          title: "",
    //          images: SvgImagesPath.onboardImagetwo,
    //          onTap: () {
               
    //          },
    //        ),
    //        ReUsebody(),
    //        ReUsebody(),
    //    ],
    // );
  }
}

class ReUsebody extends StatelessWidget {
  final String title;
  final String images;
  void Function() onTap;
  final String buttonTitle;

  ReUsebody({
    super.key,
    required this.images,
    required this.title,
    required this.onTap,
    required this.buttonTitle,
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
             ImagePart(images: images,),
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
                 InkWell(
                   onTap: onTap,
                   child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Container(
                       width: MediaQuery.of(context).size.width,
                       height: 55,
                       decoration: BoxDecoration(
                         color: Colors.black,
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
                 ),
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
  const ImagePart({
    super.key,
    required this.images,
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
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 30,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5)
              ),
            ),
          )),
        ),
      ],
    );
  }
}