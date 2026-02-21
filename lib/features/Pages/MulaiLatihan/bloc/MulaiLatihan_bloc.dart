import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Config.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_event.dart';
import 'package:frontend_fisio/features/Pages/MulaiLatihan/bloc/MulaiLatihan_state.dart';
import 'package:video_player/video_player.dart';

class MLatihanBloc extends Bloc<MulailatihanEvent, MLatihanState> {
  FlickManager? _flickManager;
  List<JadwalDetailModel> _listGerakan = []; // Updated type

  MLatihanBloc() : super(MLatihanInitial()) {
    on<InitializeLatihanEvent>((event, emit) async {
      // 1. Validasi List Gerakan
      try {
        _listGerakan = event.gerakan;
        print('📝 [MULAI_LATIHAN] Initialize: ${_listGerakan.length} videos');

        if (_listGerakan.isEmpty) {
          emit(MLatihanError("Tidak ada data video latihan (List Kosong)"));
          return;
        }

        // 2. Validasi Video Pertama
        final firstVideo = _listGerakan[0];
        // Note: videoUrl is inside nested latihan object
        final videoUrl = firstVideo.latihan.videoUrl;
        
        if (videoUrl == null || videoUrl.isEmpty) {
          emit(MLatihanError("URL video pertama tidak valid/kosong"));
          return;
        }

        // 3. Trigger Load Video Pertama
        print('▶️ [MULAI_LATIHAN] Loading first video: ${firstVideo.latihan.namaLatihan}');
        add(SelectVideoEvent(videoUrl));

      } catch (e) {
        print('❌ [MULAI_LATIHAN] Init Failed: $e');
        emit(MLatihanError("Gagal memuat latihan: $e"));
      }
    });

    on<SelectVideoEvent>((event, emit) async {
      try {
        // Emit loading state to clear previous player from UI
        emit(MLatihanLoading());
        print('🔄 [MULAI_LATIHAN] SelectVideoEvent: ${event.videoUrl}');

        // 1. Dispose old manager if exists
        if (_flickManager != null) {
          print('🗑️ [MULAI_LATIHAN] Disposing old FlickManager...');
          _flickManager!.dispose();
          _flickManager = null;
        }

        // 2. Build & Validate URL
        String videoUrl = event.videoUrl.trim();
        if (videoUrl.isEmpty) {
           throw Exception("URL Video kosong");
        }

        print('📝 [MULAI_LATIHAN] Original: $videoUrl');
        String fullUrl = ApiConfig.buildMediaUrl(videoUrl);
        print('🎬 [MULAI_LATIHAN] Final URL: $fullUrl');

        // 3. Create Controller
        print('⏳ [MULAI_LATIHAN] Creating Controller...');
        final videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(fullUrl),
        );

        // 4. Initialize with TIMEOUT (Prevent Stuck Loading)
        print('⏳ [MULAI_LATIHAN] Initializing with 15s timeout...');
        await videoPlayerController.initialize().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("Koneksi timeout (15 detik). Periksa internet anda.");
          },
        );

        // 🔥 CRITICAL: Set Looping
        await videoPlayerController.setLooping(true);
        
        print('✅ [MULAI_LATIHAN] Init done. Duration: ${videoPlayerController.value.duration}');

        // 5. Create NEW FlickManager
        print('✨ [MULAI_LATIHAN] Creating new FlickManager...');
        _flickManager = FlickManager(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
        );

        // 6. Emit Loaded with NEW manager
        emit(MLatihanLoaded(
          gerakan: _listGerakan,
          flickManager: _flickManager,
          currentUrl: event.videoUrl,
        ));
        
      } catch (e) {
        print('❌ [MULAI_LATIHAN] Error: $e');
        _flickManager?.dispose(); // Cleanup if failed
        _flickManager = null;
        
        String errorMsg = e.toString();
        if (errorMsg.contains('timeout')) {
          errorMsg = "Koneksi lambat/timeout. Coba lagi.";
        }
        
        emit(MLatihanError('Gagal memuat video: $errorMsg'));
      }
    });

    // 🔥 Handle navigation state changes
    on<SetNavigatingEvent>((event, emit) {
      if (state is MLatihanLoaded) {
        emit((state as MLatihanLoaded).copyWith(
          isNavigating: event.isNavigating,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _flickManager?.dispose();
    return super.close();
  }
}
