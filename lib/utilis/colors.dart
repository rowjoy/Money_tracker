import 'package:flutter/material.dart';

class ProjectColor {
   static const Color mainColr =  Color(0xff59AC77);
   static const Color blackColor = Colors.black;
   static const Color whiteColor = Colors.white;
   static const Color grey =  Colors.grey;
   static const Color blueAccent = Colors.blueAccent;

    static const Color lavenderPurple =  Color(0xFF7B61FF);
    static const Color electricPurple =  Color(0xFF9A5CFF); 
}



class ListColorCode {

 static List<Color> colorset1 = [
    ProjectColor.lavenderPurple,
    ProjectColor.electricPurple,
  ];

   static List<Color> colorset2 = [
    const Color.fromARGB(255, 255, 97, 97),
    ProjectColor.electricPurple,
  ];


}