
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/utilis/colors.dart';

class CustomAppBer extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBer({
    super.key,
    required this.title,

  });

  @override
  Size get preferredSize => Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ProjectColor.whiteColor,
      title: Text(title),
      useDefaultSemanticsOrder: false,
      automaticallyImplyLeading: false,
      leading: IconButton(
       onPressed: (){
         context.pop();
       }, 
       icon: Icon(Icons.arrow_back_ios),
     ),
    );
  }
}