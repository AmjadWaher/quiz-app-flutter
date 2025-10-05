import 'package:quiz_app/admin/data/models/answer_admin_model.dart';
import 'package:quiz_app/admin/domain/entities/answer_admin.dart';
import 'package:quiz_app/admin/domain/entities/question_admin.dart';

class QuestionAdminModel extends QuestionAdmin {
  const QuestionAdminModel({
    required super.id,
    required super.title,
    required super.options,
    required super.correctOptionIndex,
    required super.quizId,
  });

  factory QuestionAdminModel.fromJson(Map<String, dynamic> json) {
    return QuestionAdminModel(
      id: json['id'] as int,
      title: json['title'] as String,
      options: List<AnswerAdmin>.from(
        (json['answers'] as List).map(
          (option) => AnswerAdminModel.fromJson(option),
        ),
      ),
      correctOptionIndex: json['currectOptionIndex'],
      quizId: json['quizId'] as int,
    );
  }

  QuestionAdmin copyWith({
    String? title,
    List<AnswerAdmin>? options,
    int? correctOptionIndex,
  }) {
    return QuestionAdminModel(
      id: id,
      title: title ?? this.title,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      quizId: quizId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'answers': List<AnswerAdmin>.from(options),
      'correctOptionIndex': correctOptionIndex,
      'quizId': quizId,
    };
  }
}
