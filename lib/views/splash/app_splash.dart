import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/bloc/splash_bloc/splash_cubit.dart';
import 'package:moneytracker/bloc/splash_bloc/splash_state.dart';
import 'package:moneytracker/route/page_path.dart';
import 'package:moneytracker/utilis/assets_path.dart';

class AppSplashView extends StatelessWidget {
  const AppSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) => current is SplashNavigateToOnboard,
      listener: (context, state) {
        if(state is SplashNavigateToOnboard){
            context.pushReplacement(PagePath.onboardPageView);
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 AspectRatio(
                  aspectRatio: 1,
                  child: GifView.asset(IconsPath.appLogogif),
                 ),
               ],
             ),
          )
       ),
    );
  }
}