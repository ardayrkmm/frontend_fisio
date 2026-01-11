import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/LoginPages.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/bloc/login_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/RegisterPages.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/ResetPassword/ResetPassword.dart';
import 'package:frontend_fisio/features/Pages/Auth/ResetPassword/UbahPassword.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/VerifikasiPages.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_bloc.dart';
import 'package:frontend_fisio/features/Pages/Home/bloc/home_bloc.dart';
import 'package:frontend_fisio/features/Pages/Home/bloc/home_event.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/bloc/latihan_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/presentation/Mainpages.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_bloc.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_event.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/presentation/ValidasiPage.dart';
import 'package:frontend_fisio/features/Repository/AuthRepository.dart';
import 'package:frontend_fisio/features/Repository/LatihanRepository.dart';
import 'package:frontend_fisio/features/Repository/QuestionRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Pastikan binding Flutter sudah siap karena kita pakai async di main
  WidgetsFlutterBinding.ensureInitialized();

  // Cek token di storage
  final prefs = await SharedPreferences.getInstance();
  final String? token =
      prefs.getString('token'); // Asumsi key storage-nya adalah 'token'

  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Tambahkan variabel ini

  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => QuestionRepository()),
        RepositoryProvider(create: (context) => Authrepository()),
        RepositoryProvider(create: (context) => LatihanRepository()),
      ],
      // 2. Bungkus dengan MultiBlocProvider agar semua Bloc terdaftar global
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(context.read<Authrepository>()),
          ),
          BlocProvider(
              create: (context) => ProfileBloc(context.read<Authrepository>())),
          BlocProvider(
            create: (context) => VerifikasiBloc(context.read<Authrepository>()),
          ),
          BlocProvider(
            create: (context) => LatihanBloc(context.read<LatihanRepository>()),
          ),
          BlocProvider(
            create: (_) => HomeBloc()..add(LoadHomeUser()),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(context.read<Authrepository>()),
          ),
          BlocProvider(
            create: (context) =>
                QuestionBloc(context.read<QuestionRepository>())
                  ..add(LoadQuestions()),
          ),
          BlocProvider(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedIn ? '/main' : '/login',
          routes: {
            '/login': (context) => LoginPages(),
            '/register': (context) => RegisterPages(),
            '/verifikasi': (context) => Verifikasipages(),
            '/resetpassword': (context) => ResetPasswordPages(),
            '/ubahpassword': (context) => UbahpasswordPages(),
            '/validasi': (context) => QuestionPage(),
            '/main': (context) => Mainpages(),
          },
        ),
      ),
    );
  }
}
