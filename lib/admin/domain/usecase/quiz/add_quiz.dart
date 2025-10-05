import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:quiz_app/core/error/failure.dart';
import 'package:quiz_app/core/usecase/base_use_case.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/repository/base_quiz_repository_admin.dart';

class AddQuiz extends BaseUseCase<QuizAdmin, QuizParameters> {
  final BaseQuizRepositoryAdmin baseQuizRepository;

  AddQuiz(this.baseQuizRepository);
  @override
  Future<Either<Failure, QuizAdmin>> call(QuizParameters parameters) async {
    return baseQuizRepository.addQuiz(parameters);
  }
}

class QuizParameters extends Equatable {
  final int? id;
  final String title;
  final int categoryId;
  final int timeLimit;
  final String userId;
  final List<QuestionParameter> questions;

  const QuizParameters({
    this.id,
    required this.title,
    required this.categoryId,
    required this.timeLimit,
    required this.userId,
    required this.questions,
  });

  @override
  List<Object> get props => [title, categoryId, timeLimit, userId, questions];
}

class QuestionParameter extends Equatable {
  final int? id;
  final String title;
  final List<AnswerParameter> options;
  final int correctOptionIndex;

  const QuestionParameter(
    this.title,
    this.options,
    this.correctOptionIndex, {
    this.id,
  });

  @override
  List<Object> get props => [title, options, correctOptionIndex];
}

class AnswerParameter extends Equatable {
  final int? id;
  final String text;

  const AnswerParameter(this.text, {this.id});

  @override
  List<Object> get props => [text];
}
