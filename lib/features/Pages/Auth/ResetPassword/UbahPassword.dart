import 'package:flutter/material.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/core/Widget/Input.dart';

class UbahpasswordPages extends StatelessWidget {
  const UbahpasswordPages({super.key});

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
            'Masukan kode verifikasi kamu dan ganti password kamu',
            style: itemStyle.copyWith(fontWeight: regular, fontSize: 24.0),
          ),
        ],
      );
    }

    Widget bagianTengah() {
      return Column(
        children: [
          Inputs(hint: 'Kode Verifikasi', controller: TextEditingController()),
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
          Inputs(hint: 'Password Baru', controller: TextEditingController()),
          SizedBox(height: 30.0),
          Inputs(
            hint: 'Konfirmasi Password Baru',
            controller: TextEditingController(),
          ),
          SizedBox(height: 30.0),
          Buttons(
            nama: 'Dapatkan Kode',
            lebar: double.infinity,
            tinggi: 56.0,

            onPressed: () {
              // Aksi saat tombol ditekan
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
