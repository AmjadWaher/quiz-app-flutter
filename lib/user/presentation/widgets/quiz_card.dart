import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/functions/ticker.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/user/domain/entities/quiz_user.dart';
import 'package:quiz_app/user/presentation/screens/quiz_play_screen.dart';
import 'package:quiz_app/user/user.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.quiz, required this.index});
  final QuizUser quiz;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.quiz,
            color: AppTheme.primaryColor,
            size: 30,
          ),
        ),
        title: Text(
          quiz.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.question_answer_outlined,
              color: AppTheme.textSecondaryColor,
              size: 16,
            ),
            const SizedBox(width: 3),
            Text(
              '${quiz.questions.length} ${quiz.questions.length > 1 ? 'questions' : 'question'}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.timer_outlined,
              color: AppTheme.textSecondaryColor,
              size: 16,
            ),
            const SizedBox(width: 3),
            Text(
              '${quiz.timeLimte} mins',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.primaryColor,
          size: 15,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => TimerBloc(ticker: Ticker()),
              child: QuizPlayScreen(quiz: quiz),
            ),
          ));
        },
        splashColor: Colors.transparent,
      ),
    )
        .slideInRight(
            delay: Duration(milliseconds: 100 * index),
            duration: const Duration(milliseconds: 300))
        .fadeIn();
  }
}
