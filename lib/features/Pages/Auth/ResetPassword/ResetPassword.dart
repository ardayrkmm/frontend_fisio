import 'package:flutter/material.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/core/Widget/Input.dart';

class ResetPasswordPages extends StatelessWidget {
  const ResetPasswordPages({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bagianAtas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Reset Password',
            style: biruTerangStyle.copyWith(fontWeight: bold, fontSize: 30.0),
          ),
          Text(
            'Masukkan email untuk mereset password Anda',
            style: itemStyle.copyWith(fontWeight: regular, fontSize: 24.0),
          ),
        ],
      );
    }

    Widget bagianTengah() {
      return Column(
        children: [
          Inputs(
            hint: 'Email',
            controller: TextEditingController(),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 30.0),
          Buttons(
            nama: 'Dapatkan Kode',
            lebar: double.infinity,
            tinggi: 56.0,
            onPressed: () {
              Navigator.pushNamed(context, "/ubahpassword");
            },
          ),
        ],
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
