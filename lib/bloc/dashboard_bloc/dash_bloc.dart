import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/dashboard_bloc/dash_event.dart';
import 'package:moneytracker/bloc/dashboard_bloc/dash_state.dart';

class DashBoardBloc extends Bloc <IndexEvent, DashBoardState> {
  DashBoardBloc() : super (DashBoardState(activeIndex: 0)){
    on<DeshBoardChanged>((event, emit){
        emit(state.copyWith(activeIndex: event.index));
    });
  }


}