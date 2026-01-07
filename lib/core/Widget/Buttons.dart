import 'package:flutter/material.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';

class Buttons extends StatelessWidget {
  String nama;
  double lebar;
  double tinggi;
  VoidCallback onPressed;
  Buttons({
    super.key,
    required this.nama,
    required this.lebar,
    required this.tinggi,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: lebar,
        height: tinggi,
        decoration: BoxDecoration(
          color: unguTerang,
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Center(
            child: Text(
              nama,
              style: putihStyle.copyWith(fontWeight: semiBold, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
