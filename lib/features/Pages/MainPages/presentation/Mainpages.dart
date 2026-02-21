import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Aktifitas/presentation/AktifitasPage.dart';
import 'package:frontend_fisio/features/Pages/Home/presentation/HomePages.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_state.dart';
import 'package:frontend_fisio/features/Pages/MainPages/presentation/CustomNavbar.dart';
import 'package:frontend_fisio/features/Pages/Profil/presetation/ProfilPage.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/presentation/ListLatihan.dart';

class Mainpages extends StatelessWidget {
  Mainpages({super.key});

  final List<Widget> pages = [
    Homepages(),
    Aktifitaspage(),
    LatihanPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return pages[state.selectedIndex];
        },
      ),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
