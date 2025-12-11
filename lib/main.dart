import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/apps.dart';
import 'package:moneytracker/bloc/splash_bloc/splash_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
       MultiBlocProvider(
        providers: [
            BlocProvider(
              create: (_)=> SplashCubit(),
            ),
        ], 
       child: const MyApp(),
    ),
  );
}