import 'package:quiz_app/user/data/models/answer_user_model.dart';
import 'package:quiz_app/user/domain/domain_user.dart';
import 'package:quiz_app/user/domain/entities/answer_user.dart';

class QuestionUserModel extends QuestionUser {
  const QuestionUserModel({
    required super.id,
    required super.title,
    required super.answers,
    required super.correctOpionIndex,
  });

  factory QuestionUserModel.fromJson(Map<String, dynamic> json) =>
      QuestionUserModel(
        id: json['id'],
        title: json['title'],
        answers: List<AnswerUser>.from(
          (json['answers'] as List).map(
            (answer) => AnswerUserModel.fromJson(answer),
          ),
        ),
        correctOpionIndex: json['currectOptionIndex'],
      );
}
