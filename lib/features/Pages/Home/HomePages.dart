import 'package:flutter/material.dart';

import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/HomePages/CardArtikel.dart';

class Homepages extends StatelessWidget {
  const Homepages({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bagianProfil() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10000),
                    color: unguTerang,
                  ),
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Pagi,',
                      style: biruTerangStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Amad',
                      style: itemStyle.copyWith(
                        fontWeight: regular,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/notif.png')),
            ),
          ),
        ],
      );
    }

    Widget bagianLastLatihan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latihan terakhir kali',
            style: itemStyle.copyWith(fontWeight: bold, fontSize: 24.0),
          ),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage('assets/pl.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Latihan Pertama',
                          style: itemStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '15 Menit | 5 Latihan',
                          style: itemStyle.copyWith(
                            fontWeight: regular,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "Lihat Semua",
                  style: unguTerangStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget bagianArtikel() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Artikel',
                    style: itemStyle.copyWith(fontWeight: bold, fontSize: 24.0),
                  ),
                  Text(
                    'Artikel Terbaru untuk kamu',
                    style: abu2Style.copyWith(
                      fontWeight: medium,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Lihat Semua',
                style: unguTerangStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [Cardartikel(), Cardartikel(), Cardartikel()]),
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
          child: ListView(
            children: [
              bagianProfil(),
              SizedBox(height: 18),
              bagianLastLatihan(),
              SizedBox(height: 18),
              bagianArtikel(),
            ],
          ),
        ),
      ),
    );
  }
}
