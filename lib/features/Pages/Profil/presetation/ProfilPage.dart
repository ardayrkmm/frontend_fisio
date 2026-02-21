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
          // Default data
          String userName = "Pengguna";
          String userPhone = "08xxxxxxxx";

          if (state is ProfileLoaded) {
            userName = state.user.nama ?? "Pengguna";
            userPhone = state.user.noTelepon ?? "-";
          } else if (state is ProfileLoading) {
             return Container(
               height: 250,
               color: const Color(0xFF5B5AF6),
               child: const Center(child: CircularProgressIndicator(color: Colors.white)),
             );
          }

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
                      backgroundImage: AssetImage("assets/Bg.png"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit-profile');
                        },
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
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userPhone,
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
      return BlocConsumer<ProfileBloc, ProfileState>(builder: (context, state) {
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: const MenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/privacy-policy');
                },
                child: const MenuItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy Policy',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: const MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: MenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                ),
              ),
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is ProfileLoggedOut) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }

    return Scaffold(
      body: Column(
        children: [
          Header(),
          MenuProfil(),
        ],
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  'Apakah Anda yakin ingin logout?',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LogoutRequested());
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
