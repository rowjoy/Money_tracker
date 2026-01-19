class DashBoardState {
   final int activeIndex;
   const DashBoardState({required this.activeIndex});


   DashBoardState copyWith({int? activeIndex}){
      return DashBoardState(activeIndex: activeIndex ?? this.activeIndex);
   }
}