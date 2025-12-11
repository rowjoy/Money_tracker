import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/route/page_path.dart';
import 'package:moneytracker/views/onboard/onboard_view.dart';
import 'package:moneytracker/views/splash/app_splash.dart';

class AppRoute {
 static  final GoRouter router = GoRouter(
    initialLocation: PagePath.splashView,
    routes: <RouteBase>[
      GoRoute(
        path: PagePath.splashView,
        builder: (BuildContext context, GoRouterState state) {
          return AppSplashView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: PagePath.onboardPageView,
             pageBuilder: (context, state) => CustomTransitionPage(
               child: const OnboardPageView(), 
                transitionsBuilder: slideFadeTransition,
              ),
          ),
        ],
      ),
    ],
  );
}


   // 🔹 Fade transition
  Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }


// 🔹 Smooth slide from right + fade
Widget slideFadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  const begin = Offset(0.15, 0.0); // smaller offset = more subtle
  const end = Offset.zero;

  final slideTween = Tween(begin: begin, end: end).chain(
    CurveTween(curve: Curves.easeOutCubic),
  );

  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: curvedAnimation.drive(slideTween),
      child: child,
    ),
  );
}