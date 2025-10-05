import 'package:equatable/equatable.dart';
import 'package:quiz_app/admin/domain/entities/answer_admin.dart';

class QuestionAdmin extends Equatable {
  final int id;
  final String title;
  final List<AnswerAdmin> options;
  final int correctOptionIndex;
  final int quizId;

  const QuestionAdmin({
    required this.id,
    required this.title,
    required this.options,
    required this.correctOptionIndex,
    required this.quizId,
  });


  @override
  List<Object> get props => [title, options, correctOptionIndex,quizId];
}
