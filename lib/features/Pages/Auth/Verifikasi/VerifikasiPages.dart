import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/core/Widget/Input.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_bloc.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_event.dart';
import 'package:frontend_fisio/features/Pages/Auth/Verifikasi/bloc/verifikasi_state.dart';

class Verifikasipages extends StatelessWidget {
  const Verifikasipages({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    Widget bagianAtas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Verifikasi Email',
            style: biruTerangStyle.copyWith(fontWeight: bold, fontSize: 30.0),
          ),
          Text(
            'Masukkan kode untuk verifikasi akun Anda',
            style: itemStyle.copyWith(fontWeight: regular, fontSize: 24.0),
          ),
        ],
      );
    }

    Widget bagianTengah() {
      return BlocConsumer<VerifikasiBloc, VerifikasiState>(
        listener: (context, state) {
          if (state is VerifikasiSuccess) {
            Navigator.pushNamed(context, '/login');
          }
          if (state is VerifikasiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Inputs(
                hint: 'Kode Verifikasi',
                controller: otpController,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Kirim ulang kode?',
                  style: unguTerangStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              state is VerifikasiLoading
                  ? const CircularProgressIndicator()
                  : Buttons(
                      nama: 'Verifikasi',
                      lebar: double.infinity,
                      tinggi: 56.0,
                      onPressed: () {
                        context.read<VerifikasiBloc>().add(
                              VerifikasiSubmitted(
                                token: '', // Ganti dengan token yang sesuai
                                otp: otpController.text,
                              ),
                            );
                      },
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
