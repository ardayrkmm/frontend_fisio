// pages/question_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/core/Utils/Tema.dart';
import 'package:frontend_fisio/core/Widget/Buttons.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_bloc.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_event.dart';
import 'package:frontend_fisio/features/Pages/ValidasiLatihan/bloc/Validasi_state.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bagianAtas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 241,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/ils.png'),
            )),
          ),
          Text(
            'Validasi Latihan',
            style: biruTerangStyle.copyWith(fontWeight: bold, fontSize: 24.0),
          ),
          Text(
              'Isi validasi latihan anda dengan jujur, agar kami membantu anda',
              style: itemStyle.copyWith(
                fontWeight: regular,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center),
        ],
      );
    }

    return Scaffold(
      body: BlocConsumer<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionFinished) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        },
        builder: (context, state) {
          if (state is QuestionLoaded && state.questions.isNotEmpty) {
            final question = state.currentQuestion;
            final selected = state.answers[question.id] ?? [];

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: marginHorizontal,
                vertical: 16.0,
              ),
              child: ListView(
                children: [
                  bagianAtas(),
                  const SizedBox(height: 32),
                  Text(
                    "Pertanyaan",
                    style: itemStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.title,
                    style: itemStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...question.options.map(
                    (opt) => Row(
                      children: [
                        Checkbox(
                          value: selected.contains(opt.id),
                          onChanged: (_) {
                            context.read<QuestionBloc>().add(
                                  ToggleAnswer(
                                    questionId: question.id,
                                    optionId: opt.id,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          opt.label,
                          style: itemStyle.copyWith(
                            fontSize: 18,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Buttons(
                    lebar: double.infinity,
                    tinggi: 60,
                    nama: "Selanjutnya",
                    onPressed: selected.isEmpty
                        ? () {}
                        : () {
                            context.read<QuestionBloc>().add(NextQuestion());
                          },
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
