import 'package:quiz_app/admin/domain/entities/answer_admin.dart';

class AnswerAdminModel extends AnswerAdmin {
  const AnswerAdminModel({
    required super.id,
    required super.text,
    required super.questionId,
  });

  factory AnswerAdminModel.fromJson(Map<String, dynamic> json) {
    return AnswerAdminModel(
      id: json['id'] as int,
      text: json['text'] as String,
      questionId: json['questionId'] as int,
    );
  }

  AnswerAdminModel copyWith({
    String? text,
  }) {
    return AnswerAdminModel(
      id: id,
      text: text ?? this.text,
      questionId: questionId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'questionId': questionId,
    };
  }
}
