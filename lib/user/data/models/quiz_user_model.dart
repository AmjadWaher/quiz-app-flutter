import 'package:quiz_app/user/data/data_user.dart';
import 'package:quiz_app/user/domain/domain_user.dart';

class QuizUserModel extends QuizUser {
  const QuizUserModel({
    required super.id,
    required super.title,
    required super.timeLimte,
    required super.questions,
  });

  factory QuizUserModel.fromJson(Map<String, dynamic> json) => QuizUserModel(
        id: json['id'],
        title: json['title'],
        timeLimte: json['timeLimit'],
        questions: List<QuestionUser>.from(
          (json['questions'] as List).map(
            (question) => QuestionUserModel.fromJson(question),
          ),
        ),
      );
}
