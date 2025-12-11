import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/splash_bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
   Timer? _timer;
   SplashCubit() : super(SplashInitial()){
     _stateTime();
   }


   void _stateTime (){
     _timer =  Timer(const Duration(seconds: 2),(){
         if(!isClosed){
             emit(SplashNavigateToOnboard());
         }
      });
   }


   @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }


}