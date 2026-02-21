import 'package:flutter/material.dart';
import 'package:frontend_fisio/features/Models/ListVideo.dart';

class GerakanTile extends StatelessWidget {
  final LatihanVideoModel gerakan;
  final VoidCallback? onTap;

  const GerakanTile({
    super.key,
    required this.gerakan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap, // 🔥 PINDAH KE SINI
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/Bg.png",
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        gerakan.namaGerakan,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${gerakan.targetRepetisi} kali'),
      trailing: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.15),
        child: const Icon(Icons.play_arrow, color: Colors.blue),
      ),
    );
  }
}
