import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Models/gerakan.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_event.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_state.dart';

class MLatihanBloc extends Bloc<MulailatihanEvent, MLatihanState> {
  MLatihanBloc() : super(MLatihanLoading()) {
    on<LoadMulLatihan>((event, emit) {
      emit(
        MLatihanLoaded([
          GerakanModel(
            title: 'Gerakan 1',
            duration: '02.30 Minutes',
            image: 'assets/gerakan1.png',
          ),
          GerakanModel(
            title: 'Gerakan 2',
            duration: '02.00 Minutes',
            image: 'assets/gerakan2.png',
          ),
          GerakanModel(
            title: 'Gerakan 3',
            duration: '02.00 Minutes',
            image: 'assets/gerakan3.png',
          ),
        ]),
      );
    });
  }
}
