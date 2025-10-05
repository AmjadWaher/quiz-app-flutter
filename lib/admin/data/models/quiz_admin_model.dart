import 'package:quiz_app/admin/data/models/question_admin_model.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';

class QuizAdminModel extends QuizAdmin {
  const QuizAdminModel({
    required super.id,
    required super.title,
    required super.categoryId,
    required super.timeLimit,
    required super.questions,
    required super.createdAt,
    required super.updatedAt,
  });

  factory QuizAdminModel.fromJson(Map<String, dynamic> json) {
    return QuizAdminModel(
      id: json['id'] as int,
      title: json['title'] as String,
      categoryId: json['categoryId'] as int,
      timeLimit: json['timeLimit'] as int,
      questions: List<QuestionAdminModel>.from(
        (json['questions'] as List).map(
          (x) => QuestionAdminModel.fromJson(x),
        ),
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'categoryId': categoryId,
      'timeLimit': timeLimit,
      'questions': questions.map((x) => x.toJson()).toList(),
    };
  }
}
