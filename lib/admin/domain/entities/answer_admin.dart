import 'package:equatable/equatable.dart';

class AnswerAdmin extends Equatable{
  final int id;
  final String text;
  final int questionId;

  const AnswerAdmin({
    required this.id,
    required this.text,
    required this.questionId,
  });

  @override
  List<Object> get props => [id, text, questionId];
}