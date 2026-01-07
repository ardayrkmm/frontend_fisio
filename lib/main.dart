import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/LoginPages.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/RegisterPages.dart';
import 'package:frontend_fisio/features/Pages/Auth/ResetPassword/ResetPassword.dart';
import 'package:frontend_fisio/features/Pages/Auth/ResetPassword/UbahPassword.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/VerifikasiPages.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/presentation/Mainpages.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_bloc.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_event.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/presentation/ValidasiPage.dart';
import 'package:frontend_fisio/features/Repository/QuestionRepository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 halaman awal
      initialRoute: '/login',

      routes: {
        '/login': (context) => LoginPages(),
        '/register': (context) => RegisterPages(),
        '/verifikasi': (context) => Verifikasipages(),
        '/resetpassword': (context) => ResetPasswordPages(),
        '/ubahpassword': (context) => UbahpasswordPages(),
        '/validasi': (context) => BlocProvider(
              create: (context) => QuestionBloc(
                RepositoryProvider.of<QuestionRepository>(context),
              )..add(LoadQuestions()),
              child: QuestionPage(),
            ),

        // 👇 halaman utama SETELAH login

        '/main': (context) => BlocProvider(
              create: (_) => NavigationBloc(),
              child: Mainpages(),
            ),
      },
    );
  }
}
