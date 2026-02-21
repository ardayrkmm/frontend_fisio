import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_bloc.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_event.dart';
import 'package:frontend_fisio/features/Pages/Profil/bloc/Profil_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    String initialName = 'Pengguna';
    String initialPhone = '';
    String initialEmail = '';

    if (state is ProfileLoaded) {
      initialName = state.user.nama ?? '';
      initialPhone = state.user.noTelepon ?? '';
      initialEmail = state.user.email ?? '';
    }

    _nameController = TextEditingController(text: initialName);
    _phoneController = TextEditingController(text: initialPhone);
    _emailController = TextEditingController(text: initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5B5AF6),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/Bg.png"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF5B5AF6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Ubah Foto',
              style: TextStyle(
                color: Color(0xFF5B5AF6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 32),

            // Form Fields
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline,
            ),
            SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hint: '08xxxxxxxxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B5AF6),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFF5B5AF6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xFF5B5AF6),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
          UpdateProfile(
            name: _nameController.text,
            phone: _phoneController.text,
            // email tidak diupdate di sini untuk keamanan, butuh endpoint khusus atau verifikasi ulang
          ),
        );
    
    // Tampilkan snackbar loading atau tunggu state berubah (idealnnya pakai BlocListener)
    // Untuk simplifikasi, kita asumsikan sukses dan kembali, tapi user akan melihat loading di ProfilPage
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memperbarui profil...'),
        backgroundColor: Color(0xFF5B5AF6),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
