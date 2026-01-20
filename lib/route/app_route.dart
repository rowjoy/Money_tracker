import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/route/page_path.dart';
import 'package:moneytracker/views/dashboard/baseview/dashbord_view.dart';
import 'package:moneytracker/views/dashboard/home/component/all_transction_view.dart';
import 'package:moneytracker/views/dashboard/home/bg_remover/bg_remover_view.dart';
import 'package:moneytracker/views/dashboard/home/cash_out/cash_out.dart';
import 'package:moneytracker/views/dashboard/home/top_up/user_top_up.dart';
import 'package:moneytracker/views/onboard/onboard_view.dart';
import 'package:moneytracker/views/splash/app_splash.dart';

import '../views/dashboard/home/bazaar/bazaar_view.dart';

class AppRoute {
 static  final GoRouter router = GoRouter(
    initialLocation: PagePath.splashView,
    routes: <RouteBase>[
      GoRoute(
        path: PagePath.splashView,
        // builder: (BuildContext context, GoRouterState state) {
        //   return AppSplashView();
        // },
        pageBuilder: (context, state) => CustomTransitionPage(
            child: AppSplashView(), 
            transitionsBuilder: smoothPushTransition,
            transitionDuration: const Duration(milliseconds: 260),
            reverseTransitionDuration: const Duration(milliseconds: 220),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: PagePath.onboardPageView,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: OnboardPageView(), 
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
          GoRoute(
            path: PagePath.dashBordView,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: DashBordView(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
          GoRoute(
            path: PagePath.bgRemoverView,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: BgRemoverView(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
          GoRoute(
            path: PagePath.userTopUp,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: UserTopUp(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),

          GoRoute(
            path: PagePath.userCashOut,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: UserCashOut(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
          GoRoute(
            path: PagePath.allTransctionList,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: TransactionsPage(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
          GoRoute(
            path: PagePath.bazaarView,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: BazaarView(),
                transitionDuration: const Duration(milliseconds: 260),
                reverseTransitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: smoothPushTransition,
              ),
          ),
        ],
      ),
    ],
  );
}


Widget smoothPushTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
  final slide = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

  // Incoming page: slightly from right + fade + tiny scale
  final inSlideTween = Tween<Offset>(
    begin: const Offset(0.08, 0.0),
    end: Offset.zero,
  );

  final inScaleTween = Tween<double>(begin: 0.98, end: 1.0);

  // Outgoing page: subtle parallax to left (feels premium)
  final outSlideTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.03, 0.0),
  );

  return SlideTransition(
    position: secondaryAnimation.drive(CurveTween(curve: Curves.easeOutCubic)).drive(outSlideTween),
    child: FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide.drive(inSlideTween),
        child: ScaleTransition(
          scale: animation.drive(CurveTween(curve: Curves.easeOutCubic)).drive(inScaleTween),
          child: child,
        ),
      ),
    ),
  );
}

  


