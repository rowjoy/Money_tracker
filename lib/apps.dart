import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneytracker/route/app_route.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,          // ✅ GREEN STATUS BAR
          statusBarIconBrightness: Brightness.dark, // white icons
      ),
      child: MaterialApp.router(
         debugShowCheckedModeBanner: false,
         restorationScopeId: "root_app",
         routerConfig: AppRoute.router,
      ),
    );
  }
}