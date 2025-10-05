import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/user/presentation/controllers/question/question_user_bloc.dart';
import 'package:quiz_app/user/presentation/screens/quiz_result_screen.dart';
import 'package:quiz_app/user/user.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key, required this.quiz});
  final QuizUser quiz;
  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  void _nextQuestion() {
    final state = context.read<QuestionUserBloc>().state;
    if (state.currentQuestionIndex < widget.quiz.questions.length - 1) {
      context
          .read<QuestionUserBloc>()
          .add(NextQuestionRequested(state.selectedAnswerIndex));
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeQuiz(state);
    }
  }

  void _completeQuiz(QuestionUserState state) {
    context
        .read<QuestionUserBloc>()
        .add(NextQuestionRequested(state.selectedAnswerIndex));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => QuizResultScreen(
        quiz: widget.quiz,
        selectedAnswers:
            context.read<QuestionUserBloc>().state.submittedAnswers,
      ),
    ));
  }

  double progressIndicator(int currentQuestionIndex) {
    return (currentQuestionIndex + 1) / widget.quiz.questions.length;
  }

  Color _getTimerColor(double time) {
    if (time < 0.4) return Colors.green;
    if (time < 0.6) return Colors.orange;
    if (time < 0.8) return Colors.deepOrangeAccent;

    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<QuestionUserBloc>().add(InitialQuestionState());
    context.read<TimerBloc>().add(TimerStarted(
          duration: widget.quiz.timeLimte * 60,
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close),
                        color: AppTheme.textPrimaryColor,
                      ),
                      const Spacer(),
                      _timerQuiz(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocSelector<QuestionUserBloc, QuestionUserState, int>(
                    selector: (state) {
                      return state.currentQuestionIndex;
                    },
                    builder: (context, state) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: progressIndicator(state),
                        ),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                            value: value,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor),
                            minHeight: 6,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.quiz.questions.length,
                onPageChanged: (value) {
                  // context.read();
                },
                itemBuilder: (context, index) {
                  final question = widget.quiz.questions[index];
                  return _buildQuestionCard(question, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerQuiz() {
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerRunComplete) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => QuizResultScreen(
                quiz: widget.quiz,
                selectedAnswers:
                    context.read<QuestionUserBloc>().state.submittedAnswers,
              ),
            ),
          );
        }
      },
      child: BlocSelector<TimerBloc, TimerState, int>(
        selector: (state) {
          return state.duration;
        },
        builder: (context, state) {
          final minutes = ((state / 60) % 60).floor();

          final seconds = (state % 60).floor();

          final timeProgress =
              (((minutes * 60) + seconds) / (widget.quiz.timeLimte * 60));
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: CircularProgressIndicator(
                  value: timeProgress,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getTimerColor(1 - timeProgress),
                  ),
                ),
              ),
              Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(QuestionUser question, int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${index + 1}',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ...question.answers.asMap().entries.map(
            (entry) {
              final answerIndex = entry.key;
              final answer = entry.value;
              return BlocSelector<QuestionUserBloc, QuestionUserState, int>(
                selector: (state) {
                  return state.selectedAnswerIndex;
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                        color: state != -1 && state == answerIndex
                            ? AppTheme.primaryColor.withAlpha(100)
                            : AppTheme.backgroundColor,
                        border: Border.all(
                          width: state != -1 && state == answerIndex ? 1.5 : 1,
                          color: state != -1 && state == answerIndex
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          answer.text,
                          style: TextStyle(
                            color: state != -1 && state == answerIndex
                                ? AppTheme.primaryColor
                                : null,
                          ),
                        ),
                        onTap: () => context.read<QuestionUserBloc>()
                          ..add(SelectedAnswer(answerIndex)),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final state = context.read<QuestionUserBloc>().state;

                if (state.selectedAnswerIndex != -1) {
                  _nextQuestion();
                }
              },
              child: Text(
                index == widget.quiz.questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
