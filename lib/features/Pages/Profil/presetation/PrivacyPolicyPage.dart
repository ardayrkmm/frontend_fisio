import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Pengantar'),
            _buildSectionBody(
              'Kami berkomitmen untuk melindungi privasi data Anda. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda saat menggunakan aplikasi Fisioterapi kami.',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Data yang Kami Kumpulkan'),
            _buildSectionBody(
              '• Informasi Akun: Nama, nomor telepon, email\n'
              '• Data Kesehatan: Riwayat latihan, progress, achievement\n'
              '• Data Penggunaan: Aktivitas aplikasi, fitur yang digunakan\n'
              '• Lokasi: Opsional untuk fitur lokasi tertentu\n'
              '• Konten Media: Foto dan video dari sesi latihan Anda',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Bagaimana Kami Menggunakan Data'),
            _buildSectionBody(
              '• Memberi Anda layanan yang dipersonalisasi\n'
              '• Meningkatkan pengalaman pengguna\n'
              '• Mengirim notifikasi dan update\n'
              '• Analisis dan penelitian\n'
              '• Keamanan dan pencegahan penipuan',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Keamanan Data'),
            _buildSectionBody(
              'Kami menggunakan enkripsi end-to-end dan standar keamanan industri untuk melindungi data pribadi Anda. Namun, tidak ada metode transmisi internet yang 100% aman.',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Hak Anda'),
            _buildSectionBody(
              '• Hak Akses: Anda dapat meminta akses ke data pribadi kami\n'
              '• Hak Koreksi: Anda dapat memperbaiki data yang tidak akurat\n'
              '• Hak Penghapusan: Anda dapat meminta penghapusan data\n'
              '• Hak Portabilitas: Anda dapat meminta data dalam format terstruktur',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Hubungi Kami'),
            _buildSectionBody(
              'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi:\n\n'
              'Email: privacy@fisioterapi.com\n'
              'Telepon: 0800-123-4567\n'
              'Alamat: Jl. Kesehatan No. 1, Jakarta',
            ),
            SizedBox(height: 20),

            _buildSectionTitle('Perubahan Kebijakan'),
            _buildSectionBody(
              'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Perubahan akan diumumkan melalui aplikasi atau email.',
            ),
            SizedBox(height: 20),

            Center(
              child: Text(
                'Terakhir diperbarui: 11 Februari 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5B5AF6),
      ),
    );
  }

  Widget _buildSectionBody(String body) {
    return Text(
      body,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.6,
      ),
    );
  }
}
