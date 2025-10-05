// import 'package:dartz/dartz.dart';

// import 'package:quiz_app/core/error/failure.dart';
// import 'package:quiz_app/core/usecase/base_use_case.dart';
// import 'package:quiz_app/admin/domain/entities/quiz.dart';
// import 'package:quiz_app/admin/domain/repository/base_quiz_repository.dart';

// class SearchQuiz extends BaseUseCase<List<Quiz>, SearchParameters> {
//   final BaseQuizRepository baseQuizRepository;

//   SearchQuiz(this.baseQuizRepository);
//   @override
//   Future<Either<Failure, List<Quiz>>> call(SearchParameters parameters) async {
//     return baseQuizRepository.searchQuiz(parameters);
//   }
// }

// class SearchParameters {
//   final int? categoryId;
//   final String title;

//   SearchParameters(this.title, {this.categoryId});
// }
