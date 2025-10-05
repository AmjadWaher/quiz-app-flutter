import 'package:equatable/equatable.dart';
import 'package:quiz_app/user/domain/entities/question_user.dart';

class QuizUser extends Equatable {
  final int id;
  final String title;
  final int timeLimte;
  final List<QuestionUser> questions;

  const QuizUser({
    required this.id,
    required this.title,
    required this.timeLimte,
    required this.questions,
  });

  @override
  List<Object> get props => [id, title, timeLimte, questions];
}
