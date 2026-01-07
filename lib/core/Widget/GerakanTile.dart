import 'package:flutter/material.dart';
import 'package:frontend_fisio/features/Models/gerakan.dart';

class GerakanTile extends StatelessWidget {
  final GerakanModel gerakan;

  const GerakanTile({super.key, required this.gerakan});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          gerakan.image,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        gerakan.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(gerakan.duration),
      trailing: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.15),
        child: const Icon(Icons.play_arrow, color: Colors.blue),
      ),
    );
  }
}
