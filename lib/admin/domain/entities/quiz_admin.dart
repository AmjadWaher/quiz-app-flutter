import 'package:equatable/equatable.dart';

import 'package:quiz_app/admin/data/models/question_admin_model.dart';

class QuizAdmin extends Equatable {
  final int id;
  final String title;
  final int categoryId;
  final int timeLimit;
  final List<QuestionAdminModel> questions;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const QuizAdmin({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.timeLimit,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      categoryId,
      timeLimit,
      questions,
      createdAt,
    ];
  }

  QuizAdmin copyWith({
    int? id,
    String? title,
    int? categoryId,
    int? timeLimit,
    List<QuestionAdminModel>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizAdmin(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      timeLimit: timeLimit ?? this.timeLimit,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
