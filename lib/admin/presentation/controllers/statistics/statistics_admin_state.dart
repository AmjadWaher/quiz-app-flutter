// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'statistics_admin_bloc.dart';


class StatisticsAdminState extends Equatable {
  final List<QuizAdmin> latestQuiz;
  final List<StatisticsCategory> categories;
  final int totalQuiz;
  final int totalCategory;
  final Status status;
  final String errorMessage;

  const StatisticsAdminState({
    this.latestQuiz = const [],
    this.categories = const [],
    this.totalQuiz = 0,
    this.totalCategory = 0,
    this.status = Status.loading,
    this.errorMessage='',
  });

  StatisticsAdminState copyWith({
    List<QuizAdmin>? latestQuiz,
    List<StatisticsCategory>? categories,
    int? totalQuiz,
    int? totalCategory,
    Status? status,
    String? errorMessage,
  }) {
    return StatisticsAdminState(
      latestQuiz: latestQuiz ?? this.latestQuiz,
      categories: categories ?? this.categories,
      totalQuiz: totalQuiz ?? this.totalQuiz,
      totalCategory: totalCategory ?? this.totalCategory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props {
    return [
      latestQuiz,
      categories,
      totalQuiz,
      totalCategory,
      status,
      errorMessage,
    ];
  }
}

class StatisticsCategory {
  final String? name;
  final int? count;

  StatisticsCategory({
    this.name,
    this.count,
  });
}
