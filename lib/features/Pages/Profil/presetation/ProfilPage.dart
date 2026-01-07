import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Widget/ProfilePage/MenuItem.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget Header() {
      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF5B5AF6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(state.avatar),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Color(0xFF5B5AF6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  state.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.phone,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget MenuProfil() {
      return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            MenuItem(
              icon: Icons.person_outline,
              title: 'Profile',
            ),
            MenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy Policy',
            ),
            MenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
            ),
            MenuItem(
              icon: Icons.logout,
              title: 'Logout',
            ),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        body: Column(
          children: [
            Header(),
            MenuProfil(),
          ],
        ),
      ),
    );
  }
}
