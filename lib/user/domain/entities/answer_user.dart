// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AnswerUser extends Equatable {
  final int id;
  final String text;
  final int questionId;

  const AnswerUser({
    required this.id,
    required this.text,
    required this.questionId,
  });

  @override
  List<Object> get props => [id, text, questionId];
}
