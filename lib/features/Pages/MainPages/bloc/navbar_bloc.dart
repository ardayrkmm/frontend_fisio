import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_event.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<ChangeTab>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
