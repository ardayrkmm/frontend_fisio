import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/core/Widget/Input.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/bloc/login_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/bloc/login_event.dart';
import 'package:frontend_fisio/features/Pages/Auth/Login/bloc/login_state.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_bloc.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_event.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    Widget bagianAtas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: biruTerangStyle.copyWith(fontWeight: bold, fontSize: 30.0),
          ),
          Text(
            'Selamat datang kembali',
            style: itemStyle.copyWith(fontWeight: regular, fontSize: 24.0),
          ),
        ],
      );
    }

    Widget bagianTengah() {
      return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
        if (state is LoginSuccess) {
          // Trigger load profile agar data user terupdate di seluruh aplikasi
          // context.read<ProfileBloc>().add(LoadProfile()); // deprecated, handled by AuthBloc now
          
          if (state.user != null && state.token != null) {
             context.read<AuthBloc>().add(LoggedIn(user: state.user!, token: state.token!));
          }
          
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false); // Pindah halaman dan hapus stack history
        }
        if (state is LoginError) {
          // Tampilkan snackbar jika gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      }, builder: (context, state) {
        return Column(
          children: [
            Inputs(
              hint: 'Email',
              controller: emailController, // Gunakan controller
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 28.0),
            Inputs(
              hint: 'Password',
              controller: passwordController, // Gunakan controller
              obscureText: true,
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/resetpassword');
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lupa Password?',
                  style: unguTerangStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            state is LoginLoading
                ? const CircularProgressIndicator() // Tampilkan loading jika sedang proses
                : Buttons(
                    nama: 'Login',
                    lebar: double.infinity,
                    tinggi: 56.0,
                    onPressed: () {
                      // KIRIM EVENT KE BLOC
                      context.read<LoginBloc>().add(
                            LoginSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                    },
                  ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Buat Akun Baru',
                  style:
                      abu2Style.copyWith(fontWeight: semiBold, fontSize: 14.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Atau masuk menggunakan',
              style: unguTerangStyle.copyWith(
                fontWeight: regular,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                border: Border.all(color: abu2, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Image.asset(
                  'assets/googelIcon.png',
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
          ],
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: marginHorizontal,
            vertical: marginVertical,
          ),
          child: ListView(children: [
            bagianAtas(),
            SizedBox(
              height: 20,
            ),
            bagianTengah()
          ]),
        ),
      ),
    );
  }
}
