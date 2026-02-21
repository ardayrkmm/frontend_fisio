import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_fisio/core/Utils/Tema.dart';

import 'package:frontend_fisio/features/Pages/Home/bloc/home_bloc.dart';
import 'package:frontend_fisio/features/Pages/Home/bloc/home_state.dart';
import 'package:frontend_fisio/features/Pages/ListLatihan/presentation/ListLatihan.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_bloc.dart';
import 'package:frontend_fisio/features/Bloc/Auth/auth_state.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_event.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart'; // For JadwalFaseData
import 'package:frontend_fisio/features/Models/HomeModels.dart'; // For HomeHistoryData

class Homepages extends StatelessWidget {
  const Homepages({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bagianProfil({
      required String greeting,
    }) {
      return GestureDetector(
        onTap: () {
          // Show user profile dialog when tapped
          // Access current name from ProfileBloc if available
          // Access current name from AuthBloc if available
          final state = context.read<AuthBloc>().state;
          String currentName = "Pengguna";
          if (state is Authenticated) {
            currentName = state.user.nama ?? "Pengguna";
          }
          _showProfileDialog(context, currentName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting,',
                          style: biruTerangStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 24.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            String displayName = "Pengguna";
                            if (state is Authenticated) {
                              displayName = state.user.nama ?? "Pengguna";
                            }
                            // Fallback to ProfileBloc if AuthBloc doesn't have it (optional, but good for transition)
                            // or just stick to AuthBloc since we load it on AppStarted
                            
                            return Text(
                              '$displayName',
                              style: itemStyle.copyWith(
                                fontWeight: regular,
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                // Show notifications when clicked
                _showNotificationsDialog(context);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/notif.png')),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget bagianLastLatihan(HomeHistoryData? lastWorkout) {
      if (lastWorkout == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latihan terakhir kali',
              style: itemStyle.copyWith(fontWeight: bold, fontSize: 24.0),
            ),
            SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: unguTerang.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: unguTerang.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  'Kamu belum melakukan latihan apa-apa.',
                  style: itemStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 16.0,
                    color: abu2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latihan terakhir kali',
            style: itemStyle.copyWith(fontWeight: bold, fontSize: 24.0),
          ),
          SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage('assets/pl.jpg'), // Static for now
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lastWorkout.latihan,
                              style: itemStyle.copyWith(
                                fontWeight: bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              'Akurasi: ${(lastWorkout.akurasi * 100).toStringAsFixed(0)}% | ${lastWorkout.nilai}',
                              style: itemStyle.copyWith(
                                fontWeight: regular,
                                fontSize: 13.0,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                             Text(
                              lastWorkout.tanggal,
                              style: itemStyle.copyWith(
                                fontWeight: regular,
                                fontSize: 12.0,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget bagianArtikel(bool isKondisiTerisi, JadwalFaseData? activeProgram) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latihan Hari Ini',
                style: itemStyle.copyWith(fontWeight: bold, fontSize: 24.0),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate using Bottom Navbar Index 2 (List Latihan)
                  context.read<NavigationBloc>().add(ChangeTab(2));
                },
                child: Text(
                  'Lihat list latihan',
                  style: unguTerangStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Kondisi A: Belum Validasi Kondisi
          if (!isKondisiTerisi)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Kamu belum mengisi form validasi kondisi.',
                    style: itemStyle.copyWith(fontWeight: bold, color: Colors.red[800]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sistem membutuhkan data kondisimu untuk membuatkan jadwal latihan yang aman dan sesuai.',
                    style: itemStyle.copyWith(fontSize: 13, color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/test-klinis'); // Sesuaikan rute validasi Anda
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Ayo Validasi Dahulu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )
          
          // Kondisi B: Sudah validasi tapi tidak ada jadwal aktif
          else if (activeProgram == null)
             Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: unguTerang.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: unguTerang.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.event_available, color: unguTerang, size: 50),
                  SizedBox(height: 16),
                  Text(
                    'Hari ini kamu tidak ada jadwal latihan',
                    style: itemStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16.0,
                      color: abu2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          
          // Kondisi C: Ada jadwal aktif
          else
             Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                 gradient: LinearGradient(
                    colors: [unguTerang, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                 ),
                 borderRadius: BorderRadius.circular(16),
                 boxShadow: [
                    BoxShadow(color: unguTerang.withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))
                 ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activeProgram.fase,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        activeProgram.tanggalMulai,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    activeProgram.namaProgram,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${activeProgram.totalLatihan} Latihan',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Arahkan otomatis ke halaman Latihan Pages pada Tab Navbar
                        context.read<NavigationBloc>().add(ChangeTab(2));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: unguTerang,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Mulai Latihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            )
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
            child: BlocConsumer<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeLoaded) {
                  return ListView(
                    children: [
                      bagianProfil(
                        greeting: state.greeting,
                      ),
                      SizedBox(height: 18),
                      bagianLastLatihan(state.lastWorkout),
                      SizedBox(height: 18),
                      bagianArtikel(state.isKondisiTerisi, state.activeProgram),
                    ],
                  );
                }
                return const SizedBox();
              },
              listener: (context, state) {
                if (state is HomeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            )),
      ),
    );
  }

  /// Show user profile dialog when profile is tapped
  void _showProfileDialog(BuildContext context, String namaUser) {
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
                // Profile header
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: unguTerang,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Profil Pengguna',
                  style: itemStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  namaUser,
                  style: itemStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 16.0,
                    color: abu2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add profile edit navigation here if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: unguTerang,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Edit Profil',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
                        'Tutup',
                        style: TextStyle(color: Colors.black),
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

  /// Show notifications dialog when notification icon is tapped
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifikasi',
                      style: itemStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(),
                SizedBox(height: 16.0),
                // Notification list
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildNotificationItem(
                        title: 'Latihan Baru',
                        message: 'Latihan baru telah tersedia untuk hari ini',
                        time: '2 jam yang lalu',
                      ),
                      SizedBox(height: 12.0),
                      _buildNotificationItem(
                        title: 'Pengingat Latihan',
                        message:
                            'Jangan lupa latihan hari ini untuk hasil yang maksimal',
                        time: '1 jam yang lalu',
                      ),
                      SizedBox(height: 12.0),
                      _buildNotificationItem(
                        title: 'Pencapaian',
                        message:
                            'Kamu telah menyelesaikan 10 latihan berturut-turut!',
                        time: '1 hari yang lalu',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Tidak ada notifikasi lagi',
                        style: itemStyle.copyWith(
                          fontWeight: regular,
                          fontSize: 14.0,
                          color: abu2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: unguTerang,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper widget to build notification item
  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: itemStyle.copyWith(
              fontWeight: bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            message,
            style: itemStyle.copyWith(
              fontWeight: regular,
              fontSize: 13.0,
              color: abu2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.0),
          Text(
            time,
            style: itemStyle.copyWith(
              fontWeight: regular,
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
