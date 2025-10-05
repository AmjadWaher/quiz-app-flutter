import 'package:quiz_app/user/domain/entities/answer_user.dart';

class AnswerUserModel extends AnswerUser {
  const AnswerUserModel({
    required super.id,
    required super.text,
    required super.questionId,
  });

  factory AnswerUserModel.fromJson(Map<String, dynamic> json) {
    return AnswerUserModel(
      id: json['id'],
      text: json['text'],
      questionId: json['questionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'questionId': questionId,
    };
  }
}
