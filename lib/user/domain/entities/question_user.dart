import 'package:equatable/equatable.dart';
import 'package:quiz_app/user/domain/entities/answer_user.dart';

class QuestionUser extends Equatable {
  final int id;
  final String title;
  final List<AnswerUser> answers;
  final int correctOpionIndex;

  const QuestionUser({
    required this.id,
    required this.title,
    required this.answers,
    required this.correctOpionIndex,
  });

  @override
  List<Object> get props => [id, title, answers, correctOpionIndex];
}
