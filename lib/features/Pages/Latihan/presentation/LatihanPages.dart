import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:frontend_fisio/core/Widget/LatihanPage/InfoItem.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_bloc.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_event.dart';
import 'package:frontend_fisio/features/Pages/Latihan/bloc/Latihan_state.dart';

class ExerciseCameraPage extends StatefulWidget {
  const ExerciseCameraPage({super.key});

  @override
  State<ExerciseCameraPage> createState() => _ExerciseCameraPageState();
}

class _ExerciseCameraPageState extends State<ExerciseCameraPage> {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget TopBar() {
      return Positioned(
        top: 60,
        left: 20,
        right: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Standing Row',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<ExerciseBloc>().add(PauseExercise());
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pause),
              ),
            ),
          ],
        ),
      );
    }

    BottomInfo() {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoItem(
                    title: 'Repetisi',
                    value: '${state.repetition}/${state.totalRepetition}',
                  ),
                  Text(
                    state.timer.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InfoItem(
                    title: 'Set',
                    value: '${state.set}/${state.totalSet}',
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return BlocProvider(
      create: (_) => ExerciseBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            _cameraController == null
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(_cameraController!),
            TopBar(),
            BottomInfo(),
          ],
        ),
      ),
    );
  }
}
