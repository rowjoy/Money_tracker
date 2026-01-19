import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/apps.dart';
import 'package:moneytracker/bloc/dashboard_bloc/dash_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_event.dart';
import 'package:moneytracker/bloc/onboard_bloc/onboard_bloc.dart';
import 'package:moneytracker/bloc/splash_bloc/splash_cubit.dart';
import 'package:moneytracker/database/db_helper.dart';
import 'package:moneytracker/repo/wallet_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.database;
  runApp(
       MultiBlocProvider(
        providers: [
            BlocProvider(create: (_)=> SplashCubit()),
            BlocProvider(create: (_)=> OnboardCubit()),
            BlocProvider(create: (_)=> DashBoardBloc()),
            BlocProvider(create: (_) => WalletBloc(WalletRepository())..add(WalletLoadRequested()),
        ),

        ], 
       child: const MyApp(),
    ),
  );
}

/*
How Bloc works (simple)

Button click
   ↓
Event (IncrementEvent)
   ↓
Bloc receives event
   ↓
Bloc emits new State
   ↓
UI rebuilds automatically

Bloc flow diagram

UI → Event → Bloc → State → UI


*/