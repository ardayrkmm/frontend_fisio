import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = true;
  String _selectedLanguage = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
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
        child: Column(
          children: [
            // Notification Settings
            _buildSection(
              title: 'Notifikasi',
              children: [
                _buildToggleTile(
                  title: 'Aktifkan Notifikasi',
                  subtitle: 'Terima pemberitahuan tentang latihan dan pencapaian',
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() => _notificationEnabled = value);
                  },
                ),
                Divider(height: 0),
                _buildSettingsTile(
                  title: 'Jenis Notifikasi',
                  subtitle: 'Pilih jenis notifikasi yang ingin diterima',
                  onTap: _showNotificationTypesDialog,
                ),
                Divider(height: 0),
                _buildSettingsTile(
                  title: 'Jadwal Notifikasi',
                  subtitle: '08:00 - 22:00',
                  onTap: _showScheduleDialog,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Display Settings
            _buildSection(
              title: 'Tampilan',
              children: [
                _buildToggleTile(
                  title: 'Mode Gelap',
                  subtitle: 'Aktifkan untuk mengurangi ketegangan mata',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() => _darkModeEnabled = value);
                  },
                ),
                Divider(height: 0),
                _buildDropdownTile(
                  title: 'Bahasa',
                  subtitle: _selectedLanguage,
                  onTap: _showLanguageDialog,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Security Settings
            _buildSection(
              title: 'Keamanan',
              children: [
                _buildToggleTile(
                  title: 'Autentikasi Biometrik',
                  subtitle: 'Gunakan sidik jari atau wajah untuk login',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() => _biometricEnabled = value);
                  },
                ),
                Divider(height: 0),
                _buildSettingsTile(
                  title: 'Ubah Password',
                  subtitle: 'Perbarui password akun Anda',
                  onTap: _showChangePasswordDialog,
                ),
                Divider(height: 0),
                _buildSettingsTile(
                  title: 'Sessions Aktif',
                  subtitle: 'Kelola perangkat yang terhubung',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fitur akan segera tersedia')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // About Settings
            _buildSection(
              title: 'Tentang',
              children: [
                _buildSettingsTile(
                  title: 'Versi Aplikasi',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                Divider(height: 0),
                _buildSettingsTile(
                  title: 'Bantuan & Dukungan',
                  subtitle: 'Hubungi tim dukungan kami',
                  onTap: _showHelpDialog,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Clear Cache Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _clearCache,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Hapus Cache',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B5AF6),
            ),
          ),
        ),
        Container(
          color: Colors.grey[50],
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFF5B5AF6),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  void _showNotificationTypesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Jenis Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Pengingat Latihan'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Pencapaian'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Berita & Update'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Jadwal Notifikasi'),
        content: Text('Pilih waktu mulai dan akhir notifikasi'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batalkan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text('Bahasa Indonesia'),
              value: 'Bahasa Indonesia',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value ?? 'Bahasa Indonesia');
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value ?? 'English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batalkan'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password berhasil diubah'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bantuan & Dukungan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hubungi kami melalui:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('Email: support@fisioterapi.com'),
            Text('Telepon: 0800-123-4567'),
            Text('WhatsApp: +62 812-3456-7890'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cache berhasil dihapus'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
