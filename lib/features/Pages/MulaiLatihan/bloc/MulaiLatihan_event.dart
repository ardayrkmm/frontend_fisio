import 'package:frontend_fisio/features/Models/JadwalModels.dart'; // Import JadwalModels

abstract class MulailatihanEvent {}

class LoadMulLatihan extends MulailatihanEvent {}

class InitializeLatihanEvent extends MulailatihanEvent {
  final List<JadwalDetailModel> gerakan; // Updated type
  InitializeLatihanEvent(this.gerakan);
}

// Dipanggil saat salah satu list video diklik
class SelectVideoEvent extends MulailatihanEvent {
  final String videoUrl;
  SelectVideoEvent(this.videoUrl);
}

// 🔥 Event untuk set navigation state
class SetNavigatingEvent extends MulailatihanEvent {
  final bool isNavigating;
  SetNavigatingEvent(this.isNavigating);
}
