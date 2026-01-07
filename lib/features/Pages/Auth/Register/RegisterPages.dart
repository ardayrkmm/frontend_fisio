import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/core/Widget/Input.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_event.dart';
import 'package:frontend_fisio/features/Pages/Auth/Register/bloc/register_state.dart';

class RegisterPages extends StatelessWidget {
  const RegisterPages({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController namaController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    Widget bagianAtas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Register',
            style: biruTerangStyle.copyWith(fontWeight: bold, fontSize: 30.0),
          ),
          Text(
            'Buat akun disini untuk akses fitur aplikasi',
            style: itemStyle.copyWith(fontWeight: regular, fontSize: 24.0),
          ),
        ],
      );
    }

    Widget bagianTengah() {
      return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pushNamed(context, "/verifikasi");
          }
          if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Inputs(
                  hint: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 28.0),
              Inputs(hint: 'Nama', controller: namaController),
              SizedBox(height: 28.0),
              Inputs(
                  hint: 'No. Handphone',
                  controller: phoneController,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 28.0),
              Inputs(
                  hint: 'Password',
                  controller: passwordController,
                  obscureText: true),
              SizedBox(height: 30.0),

              // Tombol dengan kondisi Loading
              state is RegisterLoading
                  ? const CircularProgressIndicator()
                  : Buttons(
                      nama: 'Register',
                      lebar: double.infinity,
                      tinggi: 56.0,
                      onPressed: () {
                        context.read<RegisterBloc>().add(
                              RegisterSubmitted(
                                email: emailController.text,
                                nama: namaController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                    ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Sudah punya akun? Login',
                    style: abu2Style.copyWith(
                        fontWeight: semiBold, fontSize: 14.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Atau buat menggunakan',
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
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: marginHorizontal,
            vertical: marginVertical,
          ),
          child: ListView(children: [bagianAtas(), bagianTengah()]),
        ),
      ),
    );
  }
}
