import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_event.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_state.dart';
import 'package:frontend_fisio/features/Models/pose_result.dart';
import 'package:frontend_fisio/features/Models/JadwalModels.dart'; // Changed import
import 'package:frontend_fisio/features/Pages/Latihan/service/realtime_pose_service.dart';
import 'package:frontend_fisio/features/Pages/Latihan/service/realtime_socket_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart'; // 🆕 TTS Import
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  Timer? _timer;

  final RealtimePoseService _poseService = RealtimePoseService();
  final RealtimeSocketService _poseWebSocketService = RealtimeSocketService();
  StreamSubscription? _socketSubscription;
  StreamSubscription? _summarySubscription;

  // 🔊 Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // 🗣️ TTS
  final FlutterTts _tts = FlutterTts();
  DateTime? _lastSpokenTime;
  static const Duration _ttsCooldown = Duration(seconds: 2);

  bool _isProcessingImage = false;

  // ⏳ HOLD-BASED REP LOGIC
  DateTime? _holdStartTime;
  bool _holdCompleted = false;
  static const Duration _holdDuration = Duration(seconds: 3); 

  // ⏳ GRACE TOLERANCE
  DateTime? _lastIncorrectTime;
  static const Duration _graceDuration = Duration(milliseconds: 800);

  // 📈 SMOOTHING
  double _smoothedConfidence = 0.0;

  // 🕒 THROTTLE SOCKET PROCESSING
  DateTime? _lastProcessedTime;
  static const Duration _processThrottle = Duration(milliseconds: 400);

  // 🔊 Sound Debounce
  DateTime? _lastWrongSoundTime;
  static const Duration _wrongSoundDebounce = Duration(seconds: 3);

  String normalize(String input) {
    return input.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
  }

  bool _isMatchingExercise(String target, String predicted) {
    if (target.isEmpty || predicted.isEmpty) return false;
    final normTarget = normalize(target);
    final normPredicted = normalize(predicted);
    return normTarget == normPredicted;
  }

  double _handleHoldLogic(bool isCorrect) {
    _handleGraceReset(isCorrect);
      
    if (isCorrect && _holdStartTime == null && !_holdCompleted) {
        _holdStartTime = DateTime.now();
    }

    if (_holdStartTime != null) {
        final holdElapsed = DateTime.now().difference(_holdStartTime!);
        final progress = (holdElapsed.inMilliseconds / _holdDuration.inMilliseconds).clamp(0.0, 1.0);
        
        if (holdElapsed >= _holdDuration && !_holdCompleted) {
            _holdCompleted = true;
            add(IncrementRepetition());
        }
        return progress;
    }
    return 0.0;
  }

  void _handleGraceReset(bool isCorrect) {
    if (isCorrect) {
        _lastIncorrectTime = null;
    } else {
        _lastIncorrectTime ??= DateTime.now();
        if (DateTime.now().difference(_lastIncorrectTime!) > _graceDuration) {
            _holdStartTime = null;
            _holdCompleted = false;
        }
    }
  }

  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  ExerciseBloc() : super(const ExerciseState()) {
    _initTts(); // 🆕 Init TTS

    on<StartRest>(_onStartRest);
    on<CompleteRest>(_onCompleteRest);

    on<InitCamera>(_onInitCamera);
    on<DisposeCamera>(_onDisposeCamera);
    on<NextExercise>(_onNextExercise);
    on<StartExercise>(_onStartExercise);
    on<PauseExercise>(_onPauseExercise);
    on<ResumeExercise>(_onResumeExercise);
    on<UpdateTimer>(_onUpdateTimer);
    on<IncrementRepetition>(_onIncrementRepetition);
    on<IncrementSet>(_onIncrementSet);
    on<CompleteExercise>(_onCompleteExercise);
    on<FailExercise>(_onFailExercise);
    on<PoseDetected>(_onPoseDetected);
    on<TogglePoseDetection>(_onTogglePoseDetection);
    on<ToggleUI>(_onToggleUI);
    on<UpdateSocketData>(_onUpdateSocketData); 
    on<FlipCamera>(_onFlipCamera);
    on<SessionSummaryReceived>(_onSessionSummaryReceived);
  }

  // 🆕 TTS Init
  Future<void> _initTts() async {
    await _tts.setLanguage("id-ID");
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  // 🆕 Speak Logic
  Future<void> _speakWrong() async {
    if (_lastSpokenTime != null &&
        DateTime.now().difference(_lastSpokenTime!) < _ttsCooldown) {
      return; // cooldown active
    }

    _lastSpokenTime = DateTime.now();

    try {
      await _tts.stop();
      await _tts.speak("Gerakan salah, perbaiki posisi");
    } catch (e) {
      print("⚠️ [TTS] Error speaking: $e");
    }
  }

  Future<void> _initializePoseServices() async {
    try {
      _poseWebSocketService.connect();
      
      _socketSubscription = _poseWebSocketService.messages.listen((data) {
         final label = data['label'] ?? 'Unknown';
         final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;
         final feedback = data['feedback'] ?? '';
         final colorString = data['color'] ?? 'white';
         final bool isValid = data['is_valid'] ?? false; // 🆕 Parse isValid
         
         Color feedbackColor = Colors.white;
         if (colorString == 'green') feedbackColor = Colors.green;
         else if (colorString == 'red') feedbackColor = Colors.red;
         else if (colorString == 'yellow') feedbackColor = Colors.yellow;

         add(UpdateSocketData(
            predictedLabel: label, 
            confidence: confidence,
            feedback: feedback,
            feedbackColor: feedbackColor,
            isValid: isValid // 🆕 Pass isValid
         ));
      });

      _summarySubscription?.cancel();
      _summarySubscription = _poseWebSocketService.summaryStream.listen((data) {
        final totalBenar = (data['total_benar'] as num?)?.toInt() ?? 0;
        final totalSalah = (data['total_salah'] as num?)?.toInt() ?? 0;
        final akurasi = (data['akurasi'] as num?)?.toDouble() ?? 0.0;

        print("📊 [BLOC] Summary Received: Benar=$totalBenar, Salah=$totalSalah, Acc=$akurasi");
        add(SessionSummaryReceived(
          totalBenar: totalBenar,
          totalSalah: totalSalah,
          akurasi: akurasi,
        ));
      });

      print('✅ [POSE] Services ready & Socket connected');
    } catch (e) {
      print('❌ [POSE] Init error: $e');
    }
  }

  Future<void> _playWrongSound() async {
    final now = DateTime.now();
    if (_lastWrongSoundTime == null || now.difference(_lastWrongSoundTime!) > _wrongSoundDebounce) {
      _lastWrongSoundTime = now;
      try {
        await _audioPlayer.play(AssetSource('audio/wrong.mp3'));
      } catch (e) {
        print("⚠️ [AUDIO] Failed to play wrong sound: $e");
      }
    }
  }
  
  // ... (Rest of code ...)

  
  // ======================================================
  // CAMERA & INIT
  // ======================================================
  Future<void> _onInitCamera(
    InitCamera event,
    Emitter<ExerciseState> emit,
  ) async {
    print('📷 [CAMERA] Initializing with exercise: ${event.latihanData.latihan.namaLatihan}'); // Nested access
    
    // Init Services
    await _initializePoseServices();

    final cameras = await availableCameras();
    // Default to front camera
  
    CameraDescription? camera;

    try {
       camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
       camera = cameras.first;
    }

    final controller = CameraController(
      camera,
      ResolutionPreset.low, // 🔥 LOW resolution for performance
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();
    
    // Determine rotation dynamically
    InputImageRotation rotation = InputImageRotation.rotation0deg;
    if (Platform.isAndroid) {
         // Calculate rotation based on sensor orientation and lens direction
         final sensorOrientation = camera.sensorOrientation;
         rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ?? InputImageRotation.rotation0deg;
    }

    final target = event.latihanData.latihan.target; // Helper
    print('📊 [CAMERA] Target: ${target.set} sets × ${target.repetisi} reps');
    print('🔄 [CAMERA] Sensor Orientation: ${camera.sensorOrientation}, Rotation: $rotation');

    // Init State
    emit(state.copyWith(
      cameraController: controller,
      isCameraReady: true,
      latihanData: event.latihanData,
      allExercises: event.allExercises,
      currentIndex: event.currentIndex,
      repetition: 0,
      set: 0,
      timer: 0, 
      session: ExerciseSession.initial, // Start initial, will jump to main
      rotation: rotation,
      currentCameraIndex: 1, // Front (Default)
    ));

    // Langsung mulai latihan (atau pending start)
    add(StartExercise());
    
    if (state.isPoseDetectionEnabled) {
      _startPoseDetection();
    }
  }

  Future<void> _onDisposeCamera(
    DisposeCamera event,
    Emitter<ExerciseState> emit,
  ) async {
    _timer?.cancel();
    _socketSubscription?.cancel();
    _poseWebSocketService.disconnect();
    _poseService.close();
    _audioPlayer.dispose(); // Dispose audio
    await state.cameraController?.dispose();
    
    emit(state.copyWith(isCameraReady: false));
  }

  // ... Session Handlers ...
  void _onStartRest(StartRest event, Emitter<ExerciseState> emit) {
    print('💤 [REST] Starting 15s rest...');
    emit(state.copyWith(
      session: ExerciseSession.resting,
      timer: 15.0, // 15 seconds rest fixed
      status: 'running',
    ));

    _startTimer(onComplete: () {
      add(CompleteRest());
    });
  }

  void _onCompleteRest(CompleteRest event, Emitter<ExerciseState> emit) {
    _timer?.cancel();
    add(StartExercise()); 
  }

  // ... Exercise Logic ...
  void _startTimer({required Function onComplete}) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        final newTime = state.timer - 0.1;
        if (newTime <= 0) {
          timer.cancel();
          onComplete();
        } else {
          add(UpdateTimer(newTime: newTime));
        }
      },
    );
  }

  void _onNextExercise(NextExercise event, Emitter<ExerciseState> emit) {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= state.allExercises.length) {
      print('✅ [LATIHAN] Semua latihan selesai!');
      emit(state.copyWith(
        status: 'allCompleted',
        session: ExerciseSession.completed,
      ));
      _saveSession(emit, isAllCompleted: true); // Save final session
      return;
    }

    final nextExercise = state.allExercises[nextIndex];
    // Save previous session here if needed differently, but for now we save per exercise in CompleteExercise
    
    emit(state.copyWith(
      currentIndex: nextIndex,
      latihanData: nextExercise,
      repetition: 0,
      set: 0,
      timer: nextExercise.latihan.target.waktu.toDouble(), // Nested access
      status: 'ready',
      session: ExerciseSession.resting,
      currentAccuracy: 0.0,
      poseResult: null,
      history: [], // Reset history for new exercise
      correctPoseCount: 0,
      totalPoseCount: 0,
    ));

    add(StartRest());
  }

  void _onStartExercise(StartExercise event, Emitter<ExerciseState> emit) {
    final currentLatihan = state.latihanData?.latihan; // Helper
    print('▶️  [EXERCISE] Starting: ${currentLatihan?.namaLatihan}'); // Nested access
    final targetWaktu = currentLatihan?.target.waktu ?? 0; // Nested access
    
    double currentTime = state.timer;
    if (targetWaktu > 0) {
        currentTime = targetWaktu.toDouble();
    }

    emit(state.copyWith(
      isRunning: true,
      isPaused: false,
      status: 'running',
      session: ExerciseSession.mainExercise,
      timer: currentTime
    ));
    
    if (targetWaktu > 0) {
        _startTimer(onComplete: () {
            add(IncrementSet());
        });
    }

    // 🆕 Start Socket Session
    if (currentLatihan != null) {
        _poseWebSocketService.startSession(
          currentLatihan.idLatihan, // Nested access
          sisi: currentLatihan.sisi, // Nested access. Pass sisi to socket!
        );
    }
    
    // 🆕 Track Start Time
    emit(state.copyWith(startTime: DateTime.now()));
  }

  void _onPauseExercise(PauseExercise event, Emitter<ExerciseState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false, isPaused: true, status: 'paused'));
  }

  void _onResumeExercise(ResumeExercise event, Emitter<ExerciseState> emit) {
     if (state.session == ExerciseSession.mainExercise) {
         add(StartExercise()); 
     } else {
         add(StartRest());
     }
  }

  void _onUpdateTimer(UpdateTimer event, Emitter<ExerciseState> emit) {
    emit(state.copyWith(timer: event.newTime));
  }

  void _onIncrementRepetition(IncrementRepetition event, Emitter<ExerciseState> emit) {
    final newRep = state.repetition + 1;
    final targetRep = state.latihanData?.latihan.target.repetisi ?? 1; // Nested

    print('✅ [REPETITION] $newRep/$targetRep');
    emit(state.copyWith(repetition: newRep));

    if (newRep >= targetRep) {
      add(IncrementSet());
    }
  }

  void _onIncrementSet(IncrementSet event, Emitter<ExerciseState> emit) {
    final newSet = state.set + 1;
    final targetSet = state.latihanData?.latihan.target.set ?? 1; // Nested

    print('✅ [SET] $newSet/$targetSet');
    emit(state.copyWith(set: newSet, repetition: 0));

    // Reset hold states
    _holdStartTime = null;
    _holdCompleted = false;
    _smoothedConfidence = 0.0;
    _lastIncorrectTime = null;

    if (newSet >= targetSet) {
      _poseWebSocketService.endExercise(); 
      if (!state.isPoseDetectionEnabled) {
         _saveSession(emit);
      }
      
      final nextIndex = state.currentIndex + 1;
      if (nextIndex < state.allExercises.length) {
         add(NextExercise());
      } else {
         emit(state.copyWith(
            status: 'completed',
            session: ExerciseSession.completed
         ));
      }
    } else {
      final targetWaktu = state.latihanData?.latihan.target.waktu ?? 0; // Nested
      emit(state.copyWith(timer: targetWaktu.toDouble()));
      add(StartExercise());
    }
  }

  Future<void> _onCompleteExercise(CompleteExercise event, Emitter<ExerciseState> emit) async {
    _timer?.cancel();
    print('🎉 [EXERCISE] Exercise Completed');
    
    emit(state.copyWith(
        status: 'completed',
        session: ExerciseSession.completed
    ));

    // 🆕 Trigger Socket Summary
    // This will cause backend to emit 'exercise_summary'
    // Which we listen to, and THEN call _saveSession inside _onSessionSummaryReceived
    print("📡 [EXERCISE] Requesting Summary from Socket...");
    _poseWebSocketService.endExercise(); 
    
    // Fallback: If socket doesn't respond in 3 seconds, save manually?
    // For now, assume socket works. If needed, we can add a timeout logic.
    // However, to be safe against no-socket scenarios (e.g. basic timer exercise), 
    // we might want to check if pose detection was enabled.
    if (!state.isPoseDetectionEnabled) {
       // If no pose detection, save immediately with local stats (likely 0)
       await _saveSession(emit);
    }
  }

  Future<void> _onSessionSummaryReceived(SessionSummaryReceived event, Emitter<ExerciseState> emit) async {
      print("💾 [BLOC] Saving Session with Socket Data...");
      await _saveSession(emit, summaryData: event);
  }

  Future<void> _saveSession(Emitter<ExerciseState> emit, {bool isAllCompleted = false, SessionSummaryReceived? summaryData}) async {
    try {
        final idUser = await _storage.read(key: 'id_user');
        final currentLatihan = state.latihanData?.latihan;
        final idLatihan = currentLatihan?.idLatihan; // Nested
        final idJadwal = state.latihanData?.idJadwal;
        
        if (idUser == null || idLatihan == null) {
            print("⚠️ [API] Missing ID User or Latihan");
            return;
        }

        // 🆕 Calculate Duration
        double actualDuration = 0;
        if (state.startTime != null) {
            actualDuration = DateTime.now().difference(state.startTime!).inSeconds.toDouble();
        } else {
             actualDuration = state.timer; // Fallback if timer used
        }

        // DECIDE DATA SOURCE: Socket Summary OR Local State
        final int correctCount = summaryData?.totalBenar ?? state.socketCorrectCount;
        final int wrongCount = summaryData?.totalSalah ?? state.socketWrongCount;
        final double accuracy = summaryData?.akurasi ?? state.averageAccuracy;

        final body = {
          "id_user": idUser,
          "id_latihan": idLatihan,
          "id_jadwal": idJadwal, 
          "total_set": state.set,
          "total_repetisi": state.repetition + (state.set * (currentLatihan?.target.repetisi ?? 0)), // Nested
          "durasi_aktual": actualDuration,
          "average_accuracy": accuracy,
          "correct_count": correctCount,
          "wrong_count": wrongCount,   
          "nilai_ukurasi": accuracy, // Added for backend matching
          "details": state.history.map((h) => {
             "label": h.predictedLabel,
             "conf": h.confidence,
             "isCorrect": h.isCorrect,
             "time": h.timestamp.toIso8601String()
          }).toList()
        };

        // Replace with your actual baseURL
        const String baseUrl = "http://192.168.1.5:5000"; // ⚠️ Update IP needed 

        print("📤 [API] Sending Save Session Request...");
        final response = await _dio.post(
            '$baseUrl/api/history', // Updated endpoint path
            data: body,
             options: Options(
                headers: {
                    "Authorization": "Bearer ${await _storage.read(key: 'jwt_token')}", // Ensure Token
                    "Content-Type": "application/json",
                },
                validateStatus: (status) => status! < 500, // Handle 4xx manually
            )
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
            print("✅ [API] Session saved successfully: ${response.data}");
            
            // Show success snackbar/toast via listener in UI if needed (via state change)
        } else {
            print("❌ [API] Failed to save session: ${response.statusCode} - ${response.data}");
        }

    } catch (e) {
        print("❌ [API] Error saving session: $e");
    }
  }

  void _onFailExercise(FailExercise event, Emitter<ExerciseState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false, status: 'failed'));
  }

  // ... Pose Logic ...
  void _startPoseDetection() {
    if (state.cameraController == null) return;
    print('▶️ [POSE] Stream started');

    state.cameraController!.startImageStream((image) async {
       if (_isProcessingImage || state.session != ExerciseSession.mainExercise) return;
       _isProcessingImage = true;

       try {
          final poseData = await _poseService.detectPose(
              image, 
              state.cameraController!.description.sensorOrientation,
              state.cameraController!.description.lensDirection
          );
          
          if (poseData == null) return;
          
          final Pose pose = poseData['pose'];
          final List<double> landmarks = poseData['landmarks']; 
          final normalizedLandmarks = landmarks; 

          if (state.isPoseDetectionEnabled) {
              _poseWebSocketService.sendPoseData(normalizedLandmarks);
          }

          add(PoseDetected(
             poseResult: PoseResult(
                poseName: state.predictedLabel, 
                confidence: state.currentAccuracy,
                pose: pose,
                landmarks: normalizedLandmarks,
                isCorrect: state.currentAccuracy > 0.8, // Visual feedback threshold
             ),
             imageSize: Size(image.width.toDouble(), image.height.toDouble()),
             rotation: state.rotation
          ));

       } catch (e) {
          print("Error processing image: $e");
       } finally {
          _isProcessingImage = false;
       }
    });
  }

  void _onPoseDetected(PoseDetected event, Emitter<ExerciseState> emit) {
     emit(state.copyWith(
        poseResult: event.poseResult,
        imageSize: event.imageSize,
        rotation: event.rotation
     ));
  }

  void _onUpdateSocketData(UpdateSocketData event, Emitter<ExerciseState> emit) {
      final now = DateTime.now();

      if (_lastProcessedTime != null &&
          now.difference(_lastProcessedTime!) < _processThrottle) {
          return;
      }
      _lastProcessedTime = now;

      // 1. Smoothing & Match
      _smoothedConfidence = (_smoothedConfidence * 0.7) + (event.confidence * 0.3);

      final currentLatihan = state.latihanData?.latihan;
      final targetName = currentLatihan?.namaLatihan ?? ''; // Nested
      final predicted = event.predictedLabel;
      
      final isMatch = _isMatchingExercise(targetName, predicted);
      
      // isCorrect requires Match and smoothed confidence
      final isCorrect = isMatch && _smoothedConfidence >= 0.7;
      final isWrong = !isCorrect; 

      // 3. Play Sound & TTS if Wrong (Throttle)
      if (state.isRunning && isWrong && event.confidence > 0.5) {
         _playWrongSound();
         _speakWrong(); 
      }

      // 4. Update Stats
      final newSocketCorrect = isCorrect ? state.socketCorrectCount + 1 : state.socketCorrectCount;
      final newSocketWrong = isWrong ? state.socketWrongCount + 1 : state.socketWrongCount;
      final newTotalCount = state.totalPoseCount + 1;
      
      // Weighted Average Accuracy
      final newAvgAccuracy = ((state.averageAccuracy * state.totalPoseCount) + event.confidence) / newTotalCount;

      // 🆕 History Appending Logic
      bool shouldAddHistory = false;
      if (state.history.isEmpty) {
         shouldAddHistory = true;
      } else {
         final lastItem = state.history.last;
         if (normalize(lastItem.predictedLabel) != normalize(event.predictedLabel)) {
             shouldAddHistory = true;
         }
      }
      
      final updatedHistory = List<ExerciseHistoryItem>.from(state.history);
      if (shouldAddHistory) {
          final historyItem = ExerciseHistoryItem(
             timestamp: DateTime.now(),
             predictedLabel: event.predictedLabel,
             confidence: event.confidence,
             isCorrect: isCorrect
          );
          updatedHistory.add(historyItem);
      }
      
      double currentHoldProgress = 0.0;

      // 5. Hold-Based Logic
      if (state.isRunning) {
          currentHoldProgress = _handleHoldLogic(isCorrect);
      } else {
          _holdStartTime = null;
          _holdCompleted = false;
          _lastIncorrectTime = null;
          currentHoldProgress = 0.0;
      }

      emit(state.copyWith(
          predictedLabel: event.predictedLabel,
          currentAccuracy: _smoothedConfidence,
          averageAccuracy: newAvgAccuracy,
          socketCorrectCount: newSocketCorrect, // 🆕
          socketWrongCount: newSocketWrong,     // 🆕
          isSocketValid: isCorrect,             // 🆕
          totalPoseCount: newTotalCount,
          feedback: event.feedback,
          feedbackColor: event.feedbackColor,
          history: updatedHistory,
          holdProgress: currentHoldProgress,    // 🆕
      ));
  }

  void _onTogglePoseDetection(TogglePoseDetection event, Emitter<ExerciseState> emit) {
     emit(state.copyWith(isPoseDetectionEnabled: !state.isPoseDetectionEnabled));
  }
  
  void _onToggleUI(ToggleUI event, Emitter<ExerciseState> emit) {
      emit(state.copyWith(isUiVisible: !state.isUiVisible));
  }

  Future<void> _onFlipCamera(FlipCamera event, Emitter<ExerciseState> emit) async {
    if (state.cameraController == null) return;
    
    try {
        await state.cameraController!.stopImageStream();
        await state.cameraController!.dispose();

        final cameras = await availableCameras();
        final currentLensDirection = state.cameraController!.description.lensDirection;
        final newLensDirection = currentLensDirection == CameraLensDirection.front 
            ? CameraLensDirection.back 
            : CameraLensDirection.front;
            
        final newCamera = cameras.firstWhere(
            (c) => c.lensDirection == newLensDirection,
            orElse: () => cameras.first,
        );

        // Init new controller
        final newController = CameraController(
          newCamera,
          ResolutionPreset.low,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
        );

        await newController.initialize();
        
        // Determine Rotation Dynamically
        InputImageRotation rotation = InputImageRotation.rotation0deg;
        if (Platform.isAndroid) {
             final sensorOrientation = newCamera.sensorOrientation;
             rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ?? InputImageRotation.rotation0deg;
        }

        print('🔄 [FLIP] New Camera: $newLensDirection, Sensor: ${newCamera.sensorOrientation}, Rotation: $rotation');

        emit(state.copyWith(
            cameraController: newController,
            rotation: rotation
        ));

        // Restart Stream
        if (state.isPoseDetectionEnabled) {
            _startPoseDetection();
        }
    } catch (e) {
        print("Error flipping camera: $e");
    }
  }
  
  @override
  Future<void> close() {
    _timer?.cancel();
    _socketSubscription?.cancel();
    _summarySubscription?.cancel();
    _poseWebSocketService.disconnect();
    _poseWebSocketService.disconnect();
    state.cameraController?.dispose();
    _audioPlayer.dispose();
    _tts.stop(); 
    return super.close();
  }
}
